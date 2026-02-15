# frozen_string_literal: true

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

  include CliMixin2::MonthlyWithDownload

  def initialize
    @r = []
    @datafiles = []
    @faraday = Faraday.new do |f|
      f.response :raise_error
    end
  end

  def add_file(path)
    name = File.basename(path)
    time = File.mtime(path)
    body = File.read(path)
    logger.info "Processing #{name}"
    add_buffer(body)
    @datafiles << { path: name, source: self.class.source_id, updated_at: time }
    self
  end

  def add_buffer(body)
    csv = FastestCSV.parse(body, col_sep: ',', row_sep: "\n")
    add_csv(csv)
    self
  end

  # Helper method to fetch initial page and extract tokens
  def fetch_page
    # Initialize form state variables
    @viewstate = nil
    @viewstate_generator = nil
    @event_validation = nil

    response = @faraday.get(URL)
    @doc = Nokogiri::HTML(response.body)
    extract_tokens(@doc)
    @doc
  end

  # Helper method to submit forms with proper token management
  def submit_form(post_data, expected_content_type = 'text/csv')
    # Add common tokens to post_data
    post_data_with_tokens = {
      '__VIEWSTATE' => @viewstate,
      '__VIEWSTATEGENERATOR' => @viewstate_generator,
      '__EVENTVALIDATION' => @event_validation
    }.merge(post_data)

    # URL-encode and submit
    encoded_data = post_data_with_tokens.map do |k, v|
      "#{URI.encode_www_form_component(k)}=#{URI.encode_www_form_component(v.to_s)}"
    end.join('&')
    response = @faraday.post(URL, encoded_data)

    # Validate response content type
    if expected_content_type == 'text/html' && !response.headers['content-type']&.include?('text/html') && !response.headers['content-type']&.include?('application/json')
      raise "Expected HTML or JSON response, got: #{response.headers['content-type']}"
    elsif expected_content_type == 'text/csv' && response.headers['content-type']&.include?('text/html')
      raise 'Cenace returned an error page'
    end

    # Update tokens if HTML or JSON response
    if response.headers['content-type']&.include?('text/html')
      @doc = Nokogiri::HTML(response.body)
      extract_tokens(@doc)
    elsif response.headers['content-type']&.include?('application/json')
      # ASP.NET AJAX partial postback - tokens are updated in the response
      # We need to parse the JSON and extract the updated tokens
      require 'json'
      json_response = JSON.parse(response.body)
      if json_response['d']
        # The response contains the updated HTML fragment
        @doc = Nokogiri::HTML(json_response['d'])
        extract_tokens(@doc)
      end
    end

    response
  end

  # Helper method to extract and validate tokens from HTML
  def extract_tokens(doc)
    extract_token = lambda { |name|
      input = doc.at("input[name='#{name}']")
      input&.[]('value')
    }

    @viewstate = extract_token.call('__VIEWSTATE')
    @viewstate_generator = extract_token.call('__VIEWSTATEGENERATOR')
    @event_validation = extract_token.call('__EVENTVALIDATION')
    raise 'Missing ViewState' unless @viewstate
    raise 'Missing EventValidation' unless @event_validation
  end

  # Extract current month date from the page
  def extract_current_month_date
    month_text = @doc.css('table#ctl00_ContentPlaceHolder1_GridRadResultado_ctl00 > tbody > tr td:first-child').text
    month_match = month_text.match(/([A-ZÁÉÍÓÚÜÑ][a-záéíóúüñ]+)\s+(\d{4})/)

    raise "Could not find month and year in month_text: #{month_text}" unless month_match

    file_month_name = month_match[1]
    file_year = month_match[2].to_i
    file_month_num = MONTHS[file_month_name]

    raise "Could not parse month from month_text: #{month_text}" unless file_month_num

    Date.new(file_year, file_month_num, 1)
  end

  def add_date(date, _save_zip = false)
    date = Date.new(date.year, date.month, 1)
    raise 'Date cannot be before 2016-04-01' if date < Date.new(2016, 4, 1)

    # Step 1: Fetch initial page
    fetch_page

    # Extract and validate current month
    current_month_date = extract_current_month_date

    if date > current_month_date
      raise "Data for #{date} is not yet available. Current month is #{current_month_date.strftime('%B %Y')}"
    elsif date < current_month_date
      # Historical date - submit date selection form (ASP.NET AJAX partial postback)
      datestr = date.strftime('%m/%d/%Y')
      client_state = {
        minDateStr: "#{datestr} 0:0:0",
        maxDateStr: "#{datestr} 0:0:0"
      }.to_json

      # Extract the min date from the date picker (2016-04-30 is the minimum allowed date)
      min_date_field = @doc.at("input[name='ctl00_ContentPlaceHolder1_FechaConsulta_AD']")
      min_date_array = JSON.parse(min_date_field['value'])
      min_date = Date.new(min_date_array[0][0], min_date_array[0][1], min_date_array[0][2])

      date_selection_data = {
        'ctl00_ContentPlaceHolder1_FechaConsulta_AD': [[min_date, 4, 30], [date.year, date.month, date.day],
                                                       [date.year, date.month, date.day]].to_json,
        'ctl00$ContentPlaceHolder1$FechaConsulta': date.strftime('%Y-%m-%d'),
        'ctl00_ContentPlaceHolder1_FechaConsulta_dateInput_ClientState': {
          enabled: true,
          emptyMessage: '',
          validationText: date.strftime('%Y-%m-%d-00-00-00'),
          valueAsString: date.strftime('%Y-%m-%d-00-00-00'),
          minDateStr: '2016-04-30-00-00-00',
          maxDateStr: '2025-11-16-00-00-00',
          lastSetTextBoxValue: date.strftime('%B de %Y')
        }.to_json,
        'ctl00_ContentPlaceHolder1_FechaConsulta_ClientState': client_state
      }
      submit_form(date_selection_data, 'text/html')
      current_month_date = extract_current_month_date

      raise "#{current_month_date} expected #{date}" if current_month_date != date
    end

    # Step 3: Submit CSV download form
    buttons = @doc.search('input[type="image"][name^="ctl00$ContentPlaceHolder1$GridRadResultado$ctl00$ctl"][name$="gbccolumn"]')
    button_name = buttons.last['name']

    csv_download_data = {
      "#{button_name}.x" => '0',
      "#{button_name}.y" => '0'
    }
    response = submit_form(csv_download_data, 'text/csv')

    # Process CSV and track file
    add_buffer(response.body)
    @datafiles << { path: "cenace_#{date.strftime('%Y%m%d')}.csv", source: self.class.source_id, updated_at: Time.now }

    self
  end

  # Convert Spanish month name to month number
  MONTHS = {
    'Enero' => 1, 'Febrero' => 2, 'Marzo' => 3, 'Abril' => 4,
    'Mayo' => 5, 'Junio' => 6, 'Julio' => 7, 'Agosto' => 8,
    'Septiembre' => 9, 'Octubre' => 10, 'Noviembre' => 11, 'Diciembre' => 12
  }.freeze

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
    DataFile.upsert_all(@datafiles, unique_by: %i[source path]) unless @datafiles.empty?
  end
end
