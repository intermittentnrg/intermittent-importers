#require 'httparty'
require 'open-uri'

module Caiso
  TZ = TZInfo::Timezone.get('US/Pacific')
  class Base
    def self.source_id
      "caiso"
    end

    FUEL_MAP = {
      "Solar" => "solar",
      "Wind" => "wind_onshore",
      "Geothermal" => "geothermal",
      "Biomass" => "biomass",
      "Biogas" => "biogas",
      "Small hydro" => "hydro",
      "Coal" => "fossil_hard_coal",
      "Nuclear" => "nuclear",
      "Natural Gas" => "fossil_gas",
      "Large Hydro" => "hydro",
      "Other" => "other",
      "Batteries" => "batteries",
    }
  end
  class Generation < Base
    def initialize(date)
      @date = date
      #current:/ outlook/SP/fuelsource.csv
      f = URI.open("http://www.caiso.com/outlook/SP/History/#{date.strftime('%Y%m%d')}/fuelsource.csv")
      @csv = CSV.parse(f, headers: true)
    end
    def points
      r = []
      fuel_sums.each do |type, v|
        v.each do |time, value|
          r << {
            time: time,
            production_type: type,
            value: value,
            country: 'US-CA'
          }
        end
      end
      #require 'pry' ; binding.pry

      r
    end
    def fuel_sums
      fuel_sums = {}
      @csv.each do |row|
        time = DateTime.strptime(@date.strftime("%Y-%m-%d ") + row.delete("Time")[1], "%Y-%m-%d %H:%M")
        time = TZ.local_to_utc(time) { |periods| periods.first }
        row.each do |type, value|
          next if type == 'Imports'
          raise type if FUEL_MAP[type].nil?
          type = FUEL_MAP[type]
          out_sum = fuel_sums[type] ||= {}
          out_sum[time] ||= 0.0
          out_sum[time] += value.to_f
        end
      end
      #require 'pry' ; binding.pry

      fuel_sums
    end
  end
end
