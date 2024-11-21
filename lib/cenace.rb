require 'fastest_csv'
require 'zip'
require 'date'
require 'tzinfo'
require 'chronic'
require 'nokogiri'
require 'faraday'

# Parse CSV files downloaded from
# https://www.cenace.gob.mx/Paginas/SIM/Reportes/EnergiaGeneradaTipoTec.aspx
class Cenace
  include SemanticLogger::Loggable

  URL = 'https://www.cenace.gob.mx/Paginas/SIM/Reportes/EnergiaGeneradaTipoTec.aspx'
  TZ = TZInfo::Timezone.get('America/Mexico_City')

  def self.source_id
    'cenace'
  end

  def self.cli(args)
    # Check for download flag
    save_zip = args.include?('--download') || args.include?('-d')
    args.reject! { |a| a == '--download' || a == '-d' }

    if args.any? && File.exist?(args.first)
      args.each do |file|
        new.add_file(file).done!
      end
    elsif args.length == 1
      # Single date
      date = Chronic.parse(args.shift).to_date
      new.add_date(date, save_zip).done!
    elsif args.length == 2
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date
      (from..to).each do |date|
        next unless date.day == 1  # Only first day of month
        new.add_date(date, save_zip).done!
      end
    else
      $stderr.puts "#{$0} [file1.zip file2.zip ...] | [date] | [from to]"
      $stderr.puts "Use -d or --download to save ZIP files"
      exit 1
    end
  end

  def initialize
    @r = []
    @faraday = Faraday.new do |f|
      f.response :raise_error
    end
  end

  def extract_token(doc, name)
    input = doc.at("input[name='#{name}']")
    input&.[]('value')
  end

  def client_state(date)
    {
      minDateStr: '2016-04-30 00:00:00',
      maxDateStr: '2025-11-16 00:00:00'
    }.to_json
  end

  def add_date(date, save_zip = false)
    if date < Date.new(2016, 4, 1)
      raise "Date cannot be before 2016-04-01"
    end

    response = nil
    logger.benchmark_info("Downloading #{date.strftime('%Y-%m')}") do
      # Get initial page to extract tokens
      response = @faraday.get(URL)

      # Extract ASP.NET tokens from HTML
      doc = Nokogiri::HTML(response.body)
      viewstate = extract_token(doc, '__VIEWSTATE')
      viewstate_generator = extract_token(doc, '__VIEWSTATEGENERATOR')
      event_validation = extract_token(doc, '__EVENTVALIDATION')

      raise "Missing ViewState" unless viewstate
      raise "Missing EventValidation" unless event_validation

      # Prepare POST data
      # Simplified POST data - only FechaInicial and FechaFinal needed
      post_data = {
        '__VIEWSTATE' => viewstate,
        '__VIEWSTATEGENERATOR' => viewstate_generator,
        '__EVENTVALIDATION' => event_validation,
        'ctl00$ContentPlaceHolder1$FechaInicial' => date.strftime('%Y-%m-%d'),
        'ctl00_ContentPlaceHolder1_FechaInicial_ClientState' => client_state(date),
        'ctl00$ContentPlaceHolder1$FechaFinal' => date.strftime('%Y-%m-%d'),
        'ctl00_ContentPlaceHolder1_FechaFinal_ClientState' => client_state(date),
        'ctl00$ContentPlaceHolder1$DescargarReportes' => 'Descargar en archivo .zip'
      }

      # Make POST request with URL-encoded data
      encoded_data = post_data.map { |k, v| "#{URI.encode_www_form_component(k)}=#{URI.encode_www_form_component(v.to_s)}" }.join('&')
      response = @faraday.post(URL, encoded_data)
    end

    # Check if we got a ZIP file
    unless response.headers['content-type']&.include?('zip')
      body_preview = response.body[0..500]
      raise "Expected ZIP file but got: #{response.headers['content-type']}"
    end

    if save_zip
      filename = "data/cenace/cenace_#{date.strftime('%Y%m')}.zip"
      FileUtils.mkdir_p('data/cenace')
      File.binwrite(filename, response.body)
      logger.info("Saved #{filename}")
    end

    add_zip(Zip::File.open_buffer(response.body), date)
  end

  def add_file(path)
    Zip::File.open(path) do |zip_file|
      add_zip(zip_file)
    end

    self
  end

  # Convert Spanish month name to month number
  MONTHS = {
    'enero' => 1, 'febrero' => 2, 'marzo' => 3, 'abril' => 4,
    'mayo' => 5, 'junio' => 6, 'julio' => 7, 'agosto' => 8,
    'septiembre' => 9, 'octubre' => 10, 'noviembre' => 11, 'diciembre' => 12
  }

  def validate_zip(zip_file, date)
    expected_month_name = date.strftime('%B')
    expected_year = date.year
    expected_month_num = date.month

    zip_file.each do |entry|
      # Extract month name and year from filename
      # Example: "Generacion Liquidada_L0 SEN noviembre 2025 v2025 12 14_05 00 01.csv"
      # We need to find the month name (noviembre) and year (2025)

      # Try to match month name in Spanish
      month_match = entry.name.match(/([A-Za-záéíóúüñ]+)\s+(\d{4})\s+v/)

      raise entry.name unless month_match
      file_month_name = month_match[1]
      file_year = month_match[2].to_i
      file_month_num = MONTHS[file_month_name.downcase]

      if file_month_num.nil?
        raise "#{entry.name} - Unknown month name: #{file_month_name}"
      elsif file_year != expected_year
        raise "#{entry.name} - Year mismatch: expected #{expected_year}, got #{file_year}"
      elsif file_month_num != expected_month_num
        raise "#{entry.name} - Month mismatch: expected #{expected_month_name} (#{expected_month_num}), got #{file_month_name} (#{file_month_num})"
      end
    end
  end

  def best_entry(zip_file)
    zip_file.max_by { |entry| entry.name }
  end

  def add_zip(zip_file, date = nil)
    validate_zip(zip_file, date) if date

    csv = FastestCSV.parse(best_entry(zip_file).get_input_stream.read, col_sep: ',', row_sep: "\n")
    add_csv(csv)
  end

  def add_csv(csv)
    # Skip header rows (8 lines: 6 descriptive + 2 column headers)
    8.times { csv.shift }

    csv.each do |row|
      date = Date.strptime(row[1], '%d/%m/%Y')
      hour = row[2].to_i - 1

      # Skip hours > 24 (bad data that should be ignored)
      if hour > 23
        logger.warn "Skipping invalid hour #{hour} on #{date}"
        next
      end

      # Mexico City doesn't observe DST, so simple conversion is sufficient
      time = TZ.local_to_utc(date.to_time + hour.hours)

      # Add each production type directly to @r with correct column indices
      @r << { time:, country: 'MX', production_type: 'wind', value: row[3].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'solar', value: row[4].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'biomass', value: row[5].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'fossil_coal', value: row[6].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'fossil_gas_ccgt', value: row[7].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'fossil_oil_diesel', value: row[8].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'geothermal', value: row[9].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'hydro', value: row[10].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'nuclear', value: row[11].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'thermal', value: row[12].to_f * 1000 }
      @r << { time:, country: 'MX', production_type: 'fossil_gas', value: row[13].to_f * 1000 }
    end

    self
  end

  def done!
    return if @r.empty?

    @from = @r.min { |a, b| a[:time] <=> b[:time] }[:time]
    @to = @r.max { |a, b| a[:time] <=> b[:time] }[:time]

    Out::Generation.run(@r, @from, @to, self.class.source_id)
  end
end
