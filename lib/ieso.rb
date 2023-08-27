require 'httparty'
module Ieso
  class Base
    TZ = TZInfo::Timezone.get('EST')
    FUEL_MAP = {
      "NUCLEAR" => "nuclear",
      "GAS" => "fossil_gas",
      "HYDRO" => "hydro",
      "WIND" => "wind_onshore",
      "SOLAR" => "solar",
      "BIOFUEL" => "biomass",
    }
    def self.source_id
      "ieso"
    end
    def points
      r = []
      fuel_sums.each do |type, v|
        v.each do |time, value|
          r << {
            time: time,
            production_type: type,
            country: 'CA-ON',
            value: value
          }
        end
      end

      r
    end
  end

  class Load
    include SemanticLogger::Loggable
    include Out::Load

    def self.source_id
      "ieso"
    end
    def initialize(date)
      @from = date.beginning_of_year
      @to = date.end_of_year

      url = "http://reports.ieso.ca/public/Demand/PUB_Demand_#{date.strftime('%Y')}.csv"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          #debug_output: $stdout
        )
      end
    end
    def points_load
      r = []
      CSV.parse(@res.body, skip_lines: /^(\\|Date)/, headers: false) do |row|
        time = Time.strptime("#{row[0]} #{row[1]}", '%Y-%m-%d %H')
        time = Ieso::Base::TZ.local_to_utc(time)
        value = row[3].to_i*1000
        r << {
          time:,
          country: 'CA-ON',
          value:
        }
      end
      #require 'pry' ; binding.pry

      r
    end
  end

  class GenerationMonth < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @res = HTTParty.get(
        "http://reports.ieso.ca/public/GenOutputCapabilityMonth/PUB_GenOutputCapabilityMonth_#{date.strftime('%Y%m')}.csv",
        #debug_output: $stdout
      )
    end
    def fuel_sums
      fuel_sums = {}
      CSV.parse(@res.body, skip_lines: /^(\\|Delivery Date)/, headers: false) do |row|
        date = Time.strptime(row.shift, '%Y-%m-%d')
        plant_name = row.shift
        type = FUEL_MAP[row.shift]
        measurement = row.shift
        hours = row
        next unless measurement == "Output"
        out_sum = fuel_sums[type] ||= {}
        hours.each_with_index do |value, hour|
          next if value.nil?
          time = date + hour.to_i.hours
          time = TZ.local_to_utc(time)
          out_sum[time] ||= 0
          out_sum[time] += value.to_i*1000
        end
      end
      #require 'pry' ; binding.pry
      fuel_sums
    end

    def points_generation
      points
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @from = date
      @to = date + 1.day

      url = "http://reports.ieso.ca/public/GenOutputCapability/PUB_GenOutputCapability_#{date.strftime('%Y%m%d')}.xml"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          #debug_output: $stdout
        )
      end
    end
    def fuel_sums
      doc = @res.parsed_response["IMODocument"]["IMODocBody"]
      date = Time.strptime(doc["Date"], '%Y-%m-%d')
      fuel_sums = {}
      doc["Generators"]["Generator"].each do |g|
        type = FUEL_MAP[g["FuelType"]]
        out_sum = fuel_sums[type] ||= {}
        g["Outputs"]["Output"].each do |o|
          time = date + (o["Hour"].to_i - 1).hours
          time = TZ.local_to_utc(time)
          out_sum[time] ||= 0
          out_sum[time] += o["EnergyMW"].to_i*1000
        end
      end

      fuel_sums
    end
    def points_generation
      points
    end
    # TODO: capability, available capacity
  end
end
