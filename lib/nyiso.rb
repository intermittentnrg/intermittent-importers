# frozen_string_literal: true

require 'faraday'
require 'fastest_csv'
require 'zip'
require 'chronic'
require 'tzinfo'

module Nyiso
  class Base
    TZ = TZInfo::Timezone.get('America/New_York')

    FUEL_MAP = {
      'Dual Fuel' => 'fossil_gas',
      'Natural Gas' => 'fossil_gas',
      'Nuclear' => 'nuclear',
      'Other Fossil Fuels' => 'other',
      'Other Renewables' => 'other_renewable',
      'Wind' => 'wind_onshore',
      'Hydro' => 'hydro_run-of-river_and_poundage'
    }.freeze

    def self.source_id
      'nyiso'
    end

    def initialize
      @r = []
      @from = nil
      @to = nil
      @faraday = Faraday.new do |f|
        f.response :raise_error
      end
    end

    def done!
      Out::Generation.run(@r, @from, @to, self.class.source_id)
    end

    def parse_csv(body)
      rows = FastestCSV.parse(body)
      return if rows.empty?

      headers = rows.shift
      csv = rows.map { |row| Hash[headers.zip(row)] }

      csv.each do |row|
        time_str = row['Time Stamp']
        row['Time Zone']
        type_name = row['Fuel Category']
        value = row['Gen MW'].to_f * 1000

        next unless time_str && type_name && !value.nil?

        time = DateTime.strptime(time_str, '%m/%d/%Y %H:%M:%S')
        utc_time = TZ.local_to_utc(time.to_time)

        production_type = FUEL_MAP[type_name]
        next unless production_type

        @r << {
          time: utc_time,
          country: 'US-NY',
          production_type: production_type,
          value: value
        }
      end
    end
  end

  class Generation < Base
    URL_FORMAT_CSV = 'http://mis.nyiso.com/public/csv/rtfuelmix/%Y%m%drtfuelmix.csv'
    URL_FORMAT_ZIP = 'http://mis.nyiso.com/public/csv/rtfuelmix/%Y%m%drtfuelmix_csv.zip'

    def self.cli(args)
      raise 'Arguments required' if args.empty?

      date = Chronic.parse(args[0]).to_date
      new.add_date(date).done!
    end

    def add_date(date)
      @date = date
      @from = TZ.local_to_utc(date.to_time)
      @to = @from + 1.day

      response = fetch_zip_or_csv(date)

      if response.headers['content-type']&.include?('zip')
        Zip::File.open_buffer(response.body) do |zip_file|
          csv_filename = date.strftime('%Y%m%drtfuelmix.csv')
          entry = zip_file.find { |e| e.name == csv_filename }
          raise "Could not find #{csv_filename} in ZIP" unless entry

          parse_csv(entry.get_input_stream.read)
        end
      else
        parse_csv(response.body)
      end

      self
    end

    private

    def fetch_zip_or_csv(date)
      url_format = date == Date.today ? URL_FORMAT_CSV : URL_FORMAT_ZIP
      url = date.strftime(url_format)
      last_modified = DataFile.last_modified(url, self.class.source_id)
      @faraday.get(url) do |req|
        req.headers['If-Modified-Since'] = last_modified if last_modified
      end
    end
  end
end
