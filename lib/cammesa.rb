# frozen_string_literal: true

require 'fast_jsonparser'
require 'chronic'
require 'faraday/net_http_persistent'
require 'zip'
require 'tzinfo'
require 'fastest_csv'
require_relative 'lambda_adapter'

module Cammesa
  class Base
    TZ = TZInfo::Timezone.get('America/Sao_Paulo')

    def faraday_get(url, params = nil)
      @faraday ||= Faraday.new do |f|
        f.adapter :net_http_persistent do |http|
          http.idle_timeout = 10
        end
      end
      @faraday.get(url, params)
    rescue Faraday::TimeoutError
      @faraday = Faraday.new do |f|
        f.adapter :lambda_adapter, function_name: 'proxy', region: 'sa-east-1'
      end
      @faraday.get(url, params)
    end

    def self.source_id
      'cammesa'
    end

    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S.%L%z'
    def parse_time(row)
      Time.strptime(row['fecha'], TIME_FORMAT)
    end

    def initialize
      @r = []
      @datafiles = []
    end

    def add(date)
      add_date(date)
    end

    def done!
      @faraday&.close
    end
  end

  # https://cammesaweb.cammesa.com/generacion-real/
  class Renovables < Base
    include SemanticLogger::Loggable

    def self.each(&block)
      from = ::Generation.joins(areas_production_type: %i[area production_type]).where('time > ?', 2.months.ago).where(
        area: { source: source_id }, production_type: { name: %w[wind solar] }
      ).pluck(Arel.sql('LAST(time, time)')).first
      from = TZ.utc_to_local(from).to_date
      (from..Date.today).each(&block)
    end

    URL = 'https://cdsrenovables.cammesa.com/exhisto/RenovablesService/GetChartTotalTRDataSource/'
    URL_TIME_FORMAT = '%d-%m-%Y'

    def self.cli(args)
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date
      (from...to).each do |date|
        new.add_date(date).done!
      end
    end

    def add_date(date)
      url = date.strftime(URL_TIME_FORMAT)
      response = faraday_get(URL, { desde: url, hasta: url })
      r = FastJsonparser.parse(response.body, symbolize_keys: false)
      raise EmptyError if r.is_a?(Hash) && r['status'] == 'NOT_FOUND'

      add_json(r)
      self
    end

    def add_json(json)
      country = 'AR'
      json.each do |row|
        time = Time.strptime(row['momento'], TIME_FORMAT)
        @r << { time:, country:, production_type: 'biomass', value: row['biocombustible'].to_f * 1000 }
        @r << { time:, country:, production_type: 'hydro_small', value: row['hidraulica'].to_f * 1000 }
        @r << { time:, country:, production_type: 'solar', value: row['fotovoltaica'].to_f * 1000 }
        @r << { time:, country:, production_type: 'wind', value: row['eolica'].to_f * 1000 }
      end
    end

    def done!
      unless @r.empty?
        @from = @r.min { |a, b| a[:time] <=> b[:time] }[:time]
        @to = @r.max { |a, b| a[:time] <=> b[:time] }[:time]
        Out::Generation.run(@r, @from, @to, self.class.source_id)
      end
      super
    end
  end

  class ProgramacionDiaria < Base
    include SemanticLogger::Loggable

    LOOKUP_URL = 'https://api.cammesa.com/pub-svc/public/findDocumentosByNemoRango?fechadesde=%Y-%m-%dT%H:%M:%S.%LZ&fechahasta=%Y-%m-%dT%H:%M:%S.%LZ&nemo=PROGRAMACION_DIARIA'
    URL = 'https://api.cammesa.com/pub-svc/public/findAttachmentByNemoId'
    FILE_FORMAT = 'PD%y%m%d.zip'

    FIELDS = %w[TIPO RGE VARIABLE H01 H02 H03 H04 H05 H06 H07 H08 H09 H10 H11
                H12 H13 H14 H15 H16 H17 H18 H19 H20 H21 H22 H23 H24].freeze

    PT_MAP = {
      'Nuclear' => :nuclear,
      'Termica' => :thermal,
      'Ren Hidro >50MW' => :hydro,
      'Ren ley 26190' => :hydro
    }.freeze

    def self.each(&block)
      from = ::Generation.joins(areas_production_type: %i[area production_type]).where('time > ?', 2.months.ago).where(
        area: { source: source_id }, production_type: { name: %w[thermal nuclear
                                                                 hydro] }
      ).pluck(Arel.sql('LAST(time, time)')).first
      from = TZ.utc_to_local(from).to_date
      (from..Date.today).each(&block)
    end

    include CliMixin2::DailyWithDownload

    def initialize
      super
      @r_gen = {}
      @r_load = {}
      @r_trans = {}
      @r_units = []
    end

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      # f.response :logger, logger
    end

    def add_date(date, save_zip = false)
      url = date.strftime(LOOKUP_URL)
      r = logger.benchmark_info(url) do
        faraday_get(url)
      end
      json = FastJsonparser.parse(r.body)
      json = json.select { |row| row[:adjuntos].first[:id] =~ /^PD\d{6}\.zip$/ }
      json.first[:adjuntos].first[:id]
      # binding.irb unless json.length == 1
      row = json.last

      if row[:adjuntos].length != 1
        filenames = row[:adjuntos].map { |a| a[:id] }.join(', ')
        logger.error "Expected 1 attachment, found #{row[:adjuntos].length}: #{filenames}"
      end

      filename = row[:adjuntos].first[:id]
      version_time = Time.strptime(row[:version], '%Y-%m-%dT%H:%M:%S.%L%z')

      # Skip if already downloaded this version
      if DataFile.where(source: self.class.source_id, path: filename)
                 .where('updated_at >= ?', version_time).exists?
        logger.info "Skipping #{filename}, already have version from #{version_time}"
        return self
      end

      params = {
        attachmentId: row[:adjuntos].first[:id],
        docId: row[:id],
        nemo: row[:nemo]
      }
      r2 = logger.benchmark_info(URL) do
        faraday_get(URL, params)
      end

      zip_buffer = r2.body
      save_zip(date, zip_buffer) if save_zip

      add_buffer(zip_buffer, date)

      @datafiles << { source: self.class.source_id, path: filename, updated_at: version_time }

      self
    end

    def save_zip(date, zip_buffer)
      filename = date.strftime('PD%y%m%d.zip')
      path = "data/cammesa/#{filename}"
      FileUtils.mkdir_p('data/cammesa')
      File.binwrite(path, zip_buffer)
      logger.info "Saved #{path}"
      self
    end

    def add_file(path)
      date = Time.strptime(File.basename(path), FILE_FORMAT).to_date
      add_buffer(File.open(path), date)
      self
    end

    def add_buffer(body, date)
      country = 'AR'

      logger.benchmark_info('parse') do
        zip = Zip::File.open_buffer(body)
        zip.each do |entry|
          if entry.name =~ /BALANCE\.csv$/

            csv_data = entry.get_input_stream.read
            csv_data = csv_data.force_encoding('UTF-8')
            if csv_data.bytes.first == 0xEF && csv_data.bytes[1] == 0xBB && csv_data.bytes[2] == 0xBF
              csv_data = csv_data.sub(/\uFEFF/, '')
            end

            csv = FastestCSV.parse(csv_data, col_sep: ',', row_sep: "\r\n")
            fields = csv.shift
            unless fields.map(&:upcase) == self.class::FIELDS
              raise "Unexpected header format: #{fields.join(', ')}"
            end

            csv.each do |row|
              row[1]
              type = row[2]

              # Process hourly data
              24.times do |h|
                value = row[h + 3].to_f * 1000
                time = date.to_time + h.hours
                time = TZ.utc_to_local(time)

                case type
                when 'Demanda Neta'
                  @r_load[time] ||= { country:, time:, value: 0 }
                  @r_load[time][:value] += value
                when 'Perdidas'
                  # Skip
                when 'Nuclear', 'Termica', 'Ren Hidro >50MW', 'Ren ley 26190'
                  production_type = PT_MAP[type]
                  key = [time, production_type]
                  @r_gen[key] ||= { country:, production_type:, time:, value: 0 }
                  @r_gen[key][:value] += value
                when 'Importacion'
                  key = [time, 'import']
                  @r_trans[key] ||= { time:, from_area: 'AR', to_area: 'other', value: 0 }
                  @r_trans[key][:value] += value
                when 'Exportacion'
                  key = [time, 'export']
                  @r_trans[key] ||= { time:, from_area: 'other', to_area: 'AR', value: 0 }
                  @r_trans[key][:value] += value
                end
              end
            end
          elsif entry.name =~ /VALORES_GENERADORES\.csv$/
            # Process unit-level data
            csv_data = entry.get_input_stream.read
            csv_data = csv_data.force_encoding('UTF-8')
            csv_data = csv_data.sub(/\uFEFF/, '') if csv_data.bytes.first == 0xEF && csv_data.bytes[1] == 0xBB && csv_data.bytes[2] == 0xBF

            csv = FastestCSV.parse(csv_data, col_sep: ',', row_sep: "\r\n")
            csv.shift # Skip header row

            csv.each do |row|
              region = row[0].gsub('"', '') rescue row[0] # Remove quotes if present
              agent = row[1].gsub('"', '') rescue row[1]  # Remove quotes if present
              unit = row[2].gsub('"', '') rescue row[2]   # Remove quotes if present
              type = row[3].gsub('"', '') rescue row[3]   # Remove quotes if present

              # Map type to production type
              production_type = case type
                               when 'EO' then 'wind'
                               when 'BG' then 'biomass'
                               when 'TV', 'HR', 'HI' then 'hydro'
                               when 'NU' then 'nuclear'
                               when 'DI', 'TG', 'CC' then 'thermal'
                               when 'FV' then 'solar'
                               else nil
                               end

              # Skip if we don't have a mapping or if this is import/export data
              next unless production_type
              next if type == 'Importacion'

              # Process hourly data
              24.times do |h|
                value_str = row[h + 4]
                # Remove quotes if present and convert to float
                value_str = value_str.gsub('"', '') if value_str.respond_to?(:gsub)
                value = value_str.to_f * 1000 # Convert MWh to kWh
                time = date.to_time + h.hours
                time = TZ.utc_to_local(time)

                @r_units << {
                  country:,
                  unit:,
                  production_type:,
                  time:,
                  value:
                }
              end
            end
          end
        end
        zip.close
      end
      self
    end

    def done!
      return if @r_gen.blank?

      @from = @r_gen.values.first[:time]
      @to = @r_gen.values.last[:time]

      Out::Generation.run(@r_gen.values, @from, @to, self.class.source_id)
      Out::Load.run(@r_load.values, @from, @to, self.class.source_id)
      Out::Transmission.run(@r_trans.values, @from, @to, self.class.source_id)
      Out::Unit.run(@r_units, @from, @to, self.class.source_id)
      DataFile.upsert_all(@datafiles, unique_by: %i[source path]) if @datafiles.any?
      super
    end
  end
end
