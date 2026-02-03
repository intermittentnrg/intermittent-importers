require 'chronic'
require 'faraday'
require 'roo'
require 'roo-xls'
require 'semantic_logger'
require 'time'
require 'json'
require 'tempfile'
require 'tzinfo'
require_relative 'lambda_adapter'

class GridIndia
  include SemanticLogger::Loggable
  include CliMixin2::MonthlyWithDownload

  TZ = TZInfo::Timezone.get('Asia/Kolkata')

  PRODUCTION_TYPE_MAPPING = {
    'THERMAL' => :fossil_coal,
    'HYDRO**' => :hydro,
    'NUCLEAR' => :nuclear,
    'GAS' => :fossil_gas,
    'WIND' => :wind,
    'SOLAR' => :solar,
    'OTHERS*' => :other_renewable
  }.freeze

  DEMAND_COLUMN = 3 # Excel column index (1-based) for DEMAND MET
  BACKEND_URL = "#{ENV['INDIA_PROXY_URL']}/https://webapi.grid-india.in/api/v1/file"
  CDN_URL = "#{ENV['INDIA_PROXY_URL']}/https://webcdn.grid-india.in/"

  def self.source_id
    'grid-india'
  end

  def initialize
    @r_gen = []
    @r_load = []
    @seen_times = Set.new
    @from = nil
    @to = nil
    @datafiles = []
    @faraday = Faraday.new do |f|
      f.adapter :lambda_adapter, function_name: 'proxy', region: 'ap-south-1'
      f.response :raise_error
    end
  end

  def add_date(date, save_file = false)
    fiscal_year_start = date.month < 4 ? date.year - 1 : date.year
    fiscal_year_end_short = (fiscal_year_start + 1) % 100

    payload = {
      '_source' => 'GRDW',
      '_type' => 'DAILY_PSP_REPORT',
      '_fileDate' => "#{fiscal_year_start}-#{fiscal_year_end_short}",
      '_month' => date.strftime('%m')
    }

    response = @faraday.post(BACKEND_URL, JSON.generate(payload), { 'Content-Type' => 'application/json' })
    file_list = JSON.parse(response.body)['retData']
    file_list.select! { |file| file['FilePath'].end_with?('.xls') }

    paths = file_list.map { |file| file['FilePath'] }
    datafiles = DataFile.where(path: paths, source: self.class.source_id).pluck(:path, :updated_at).to_h

    file_list.each do |file|
      file_path = file['FilePath']
      file_time = Time.strptime(file['ModifiedOn'], '%d-%m-%Y %H:%M')
      next if datafiles[file_path] && datafiles[file_path] >= file_time

      file_url = "#{CDN_URL}#{file_path}"
      response = logger.benchmark_info(file_url) { @faraday.get(file_url) }

      Tempfile.create(['grid_india', '.xls'], 'tmp') do |tempfile|
        tempfile.binmode
        tempfile.write(response.body)
        tempfile.flush

        report_date = process_file(tempfile.path)
        @datafiles << { path: file_path, source: self.class.source_id, updated_at: file_time }

        if save_file && report_date
          filename = "data/grid_india/#{report_date.strftime('%Y-%m-%d')}.xls"
          FileUtils.mkdir_p('data/grid_india')
          File.rename(tempfile.path, filename)
          logger.info "Saved file: #{filename}"
        end
      end
    rescue Faraday::ResourceNotFound
      logger.warn("File not found: #{file_url}")
    end

    self
  end

  def add_file(path)
    process_file(path)
    self
  end

  def process_file(path)
    workbook = Roo::Excel.new(path)

    if workbook.sheets.length < 4
      logger.warn("Missing 4th sheet in #{path}, only #{workbook.sheets.length} sheets")
      return extract_date_from_fallback_sheet(workbook)
    end

    sheet = workbook.sheet(3)

    unless time_series_sheet?(sheet)
      logger.warn("4th sheet in #{path} is not a time series sheet")
      return extract_date_from_fallback_sheet(workbook)
    end

    report_date_cell = sheet.row(1).last&.strip
    return nil if report_date_cell.empty?

    report_date = Date.parse(report_date_cell)
    production_types = parse_headers(sheet.row(3))

    (4..sheet.last_row).each do |row_idx|
      time_cell = sheet.cell(row_idx, 1)
      # Skip rows without valid time (e.g., footer text)
      next unless time_cell.to_s.match?(/\d{1,2}:\d{2}/)

      time = parse_time(time_cell, report_date)
      next unless @seen_times.add?(time)

      parse_load_data(sheet.cell(row_idx, DEMAND_COLUMN), time)
      parse_generation_data(sheet, row_idx, production_types, time)

      @from = [@from, time].compact.min
      @to = [@to, time].compact.max
    end

    report_date
  end

  def done!
    Out::Generation.run(@r_gen, @from, @to, self.class.source_id)
    Out::Load.run(@r_load, @from, @to, self.class.source_id) if @r_load.any?
    DataFile.upsert_all(@datafiles, unique_by: %i[source path])
  end

  private

  def parse_headers(header_row)
    production_types = {}

    header_row.each_with_index do |header_cell, col_idx|
      next if header_cell.nil?

      header_text = header_cell.to_s.strip
      production_type_name = header_text.split("\n").first

      if (production_type = PRODUCTION_TYPE_MAPPING[production_type_name])
        production_types[col_idx] = production_type
      end
    end

    production_types
  end

  def parse_time(time_cell, report_date)
    time_str = time_cell.to_s.strip
    match = time_str.match(/(\d{1,2}):(\d{2})/)

    hour = match[1].to_i
    minute = match[2].to_i

    time = Time.new(report_date.year, report_date.month, report_date.day, hour, minute, 0, '+05:30')
    TZ.local_to_utc(time)
  end

  def parse_load_data(demand_cell, time)
    @r_load << { time: time, country: 'IN', value: demand_cell.to_f * 1000 }
  end

  def parse_generation_data(sheet, row_idx, production_types, time)
    production_types.each do |col_idx, production_type|
      # Roo uses 1-based column indexing, so add 1 to the 0-based array index
      value_cell = sheet.cell(row_idx, col_idx + 1)
      @r_gen << { time: time, country: 'IN', production_type: production_type, value: value_cell.to_f * 1000 }
    end
  end

  def extract_date_from_fallback_sheet(workbook)
    return nil unless workbook.sheets.any?

    sheet = workbook.sheet(0)
    (1..5).each do |row_idx|
      sheet.row(row_idx).each_with_index do |cell, col_idx|
        next unless cell&.include?('Date of Reporting')

        date_cell = sheet.row(row_idx)[col_idx + 1]
        return Date.parse(date_cell&.strip) if date_cell
      end
    end
    nil
  rescue StandardError => e
    logger.warn("Failed to extract date from fallback sheet: #{e.message}")
    nil
  end

  def time_series_sheet?(sheet)
    sheet.row(1).any? { |cell| cell&.include?('Date of Reporting') }
  end
end
