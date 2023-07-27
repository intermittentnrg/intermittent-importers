#require 'httparty'
require 'open-uri'

module Caiso
  TZ = TZInfo::Timezone.get('US/Pacific')
  class Base
    def self.source_id
      "caiso"
    end

    FUELS = {
      "Time" => nil,
      "Solar" => "solar",
      "Wind" => "wind_onshore",
      "Geothermal" => "geothermal",
      "Biomass" => "biomass",
      "Biogas" => "biogas",
      "Small hydro" => "hydro_small",
      "Coal" => "fossil_hard_coal",
      "Nuclear" => "nuclear",
      "Natural Gas" => "fossil_gas",
      "Large Hydro" => "hydro_large",
      "Batteries" => "battery",
      "Imports" => nil,
      "Other" => "other",
    }
    FUEL_MAP = FUELS.values
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @date = date
      @time = @date.to_time
      @from = TZ.local_to_utc(@time) { |periods| periods.first }
      @to = @from + 1.day
      #current:/ outlook/SP/fuelsource.csv
      url = "http://www.caiso.com/outlook/SP/History/#{date.strftime('%Y%m%d')}/fuelsource.csv"
      @csv = logger.benchmark_info(url) do
        res = Faraday.get(url)
        FastestCSV.parse(res.body)
      end
      @fields = @csv.shift

      raise ENTSOE::EmptyError unless @fields.first
      raise @fields unless @fields.map(&:downcase) == FUELS.keys.map(&:downcase)
      #require 'pry' ; binding.pry
    end

    def points_generation
      r = []
      @csv.each do |row|
        #require 'pry' ; binding.pry
        #time = DateTime.strptime(@date.strftime("%Y-%m-%d ") + row[0], "%Y-%m-%d %H:%M")
        time = @date.to_time + Time.parse(row[0]).seconds_since_midnight.seconds
        time = TZ.local_to_utc(time) { |periods| periods.first }
        row.each_with_index do |value, type|
          next if type == 0 || type == 12
          raise type.to_s unless FUEL_MAP[type]
          type = FUEL_MAP[type]
          #next if type == 'Imports'
          r << {
            time: time,
            production_type: type,
            value: value.to_f.round,
            country: 'CAISO'
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
