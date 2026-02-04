require 'faraday'
require 'csv'
require 'zip'
require 'chronic'
require 'tzinfo'

module Nyiso
  class Base
    TZ = TZInfo::Timezone.get('America/New_York')
    URL_FORMAT = 'http://mis.nyiso.com/public/csv/rtfuelmix/%Y%m%drtfuelmix_csv.zip'
    def self.source_id
      'nyiso'
    end

    def initialize
      @r = []  # Array for data storage
      @from = nil
      @to = nil
    end

    def done!
      Out::Generation.run(@r, @from, @to, self.class.source_id)
    end
  end

  class Generation < Base
    FUEL_MAP = {
      'Dual Fuel' => 'fossil_gas',
      'Natural Gas' => 'fossil_gas',
      'Nuclear' => 'nuclear',
      'Other Fossil Fuels' => 'other',
      'Other Renewables' => 'other_renewable',
      'Wind' => 'wind_onshore',
      'Hydro' => 'hydro_run-of-river_and_poundage',
    }

    def self.cli(args)
      raise "Arguments required" if args.empty?
      date = Chronic.parse(args[0]).to_date
      new.add_date(date).done!
    end

    def add_date(date)
      @date = date
      @from = TZ.local_to_utc(date.to_time)
      @to = @from + 1.day

      url = date.strftime(URL_FORMAT)

      response = Faraday.get(url)
      raise "Failed to fetch data: #{response.status}" unless response.success?

      Zip::File.open_buffer(response.body) do |zip_file|
        zip_file.each do |entry|
          next if entry.directory?
          add_buffer(entry.get_input_stream.read)
        end
      end

      self
    end

    def add_buffer(body)
      csv = CSV.parse(body, headers: true)

      csv.each do |row|
        time_str = row['Time Stamp']
        timezone = row['Time Zone']
        type_name = row['Fuel Category']
        value = row['Gen MW'].to_f * 1000

        # Skip if any required fields are missing
        next unless time_str && type_name && !value.nil?

        # Parse time and convert to UTC
        time = DateTime.strptime(time_str, '%m/%d/%Y %H:%M:%S')
        # The timezone in the data is EST/EDT, but we need to handle it properly
        # We'll use the timezone info from the TZ constant
        utc_time = TZ.local_to_utc(time.to_time)

        # Map fuel type
        production_type = FUEL_MAP[type_name]
        next unless production_type  # Skip unmapped fuel types

        @r << {
          time: utc_time,
          country: 'US-NY',
          production_type: production_type,
          value:
        }
      end
    end
  end
end
