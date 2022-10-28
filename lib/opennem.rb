require 'httparty'
module Opennem
  class Base
    def self.source_id
      "opennem"
    end
    REGION_MAP = {
      "AUS-NSW" => "NSW1",
      "AUS-QLD" => "QLD1",
      "AUS-SA" => "SA1",
      "AUS-TAS" => "TAS1",
      "AUS-VIC" => "VIC1",
      "AUS-WA" => "WEM",
    }
    NETWORK_MAP = {
      "AUS-NSW" => "NEM",
      "AUS-QLD" => "NEM",
      "AUS-SA" => "NEM",
      "AUS-TAS" => "NEM",
      "AUS-VIC" => "NEM",
      "AUS-WA" => "WEM",
    }
    FUEL_MAP = {
      "coal_black" => "fossil_hard_coal",
      "coal_brown" => "fossil_brown_coal/lignite",
      "gas_ccgt" => "fossil_gas",
      "gas_ocgt" => "fossil_gas",
      "gas_recip" => "fossil_gas",
      "gas_steam" => "fossil_gas",
      "distillate" => "fossil_oil",
      "hydro" => "hydro_run-of-river_and_poundage",
      "wind" => "wind",
      "bioenergy_biogas" => "biomass",
      "bioenergy_biomass" => "biomass",
      "solar_utility" => "solar",
      "solar_rooftop" => "solar",
      # Storage
      "battery_charging" => "battery",
      "battery_discharging" => "battery",
      "pumps" => "hydro_pumped_storage",
    }
    def points
      r = []
      fuel_sums.each do |type, v|
        v.each do |time, value|
          r << {
            time: time,
            production_type: type,
            country: @country,
            value: value
          }
        end
      end

      require 'pry' ; binding.pry
      r
    end
  end
  class Generation < Base
    URL = ""
    def initialize(country: nil, date: nil)
      @country = country
      network, region = country.split(/-/)
      query = {
        month: date.strftime('%Y-%m-%d')
      }
      @res = HTTParty.get(
        "http://api.opennem.org.au/stats/power/network/fueltech/#{network}/#{region}",
        query: query,
        debug_output: $stdout
      )
    end
    def parse_interval(interval)
      case interval
      when "5m"
        5.minutes
      when "30m"
        30.minutes
      else
        raise interval
      end
    end

    def fuel_sums
      fuel_sums = {}
      @res['data'].each do |blob|
        next if blob['type'] == 'price'
        raise blob['units'] unless blob['units'] == 'MW'
        type = FUEL_MAP[blob['fuel_tech']]
        start = DateTime.strptime(blob['history']['start'], '%Y-%m-%dT%H:%M:%S%:z')
        interval = parse_interval(blob['history']['interval'])
        out_sum = fuel_sums[type] ||= {}

        #require 'pry' ; binding.pry
        blob['history']['data'].each_with_index do |value,index|
          time = start + interval * index
          out_sum[time] ||= 0.0
          if blob['fuel_tech'] == 'battery_charging'
            out_sum[time] -= value
          else
            out_sum[time] += value
          end
        end
      end

      fuel_sums
    end
  end
end
