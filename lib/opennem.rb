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
      "gas_ccgt" => "fossil_gas_ccgt",
      "gas_ocgt" => "fossil_gas_ocgt",
      "gas_recip" => "fossil_gas_reciprocating",
      "gas_steam" => "fossil_gas_steam",
      "gas_wcmg" => "fossil_gas_coal_mine_waste",
      "distillate" => "fossil_oil_distillate",
      "hydro" => "hydro",
      "wind" => "wind",
      "bioenergy_biogas" => "biogas",
      "bioenergy_biomass" => "biomass",
      "solar_utility" => "solar_utility",
      "solar_rooftop" => "solar_rooftop",
      # Storage
      "battery_charging" => "battery_charging",
      "battery_discharging" => "battery",
      "pumps" => "hydro_pumped_storage",
    }
  end
  class Generation < Base
    def initialize(country: nil, date: nil)
      @logger = SemanticLogger[Generation]
      @country = country
      network, region = country.split(/-/)
      query = {
        month: date.strftime('%Y-%m-%d')
      }
      @logger.info("month: #{query[:month]}")
      @res = HTTParty.get(
        "https://api.opennem.org.au/stats/power/network/fueltech/#{network}/#{region}",
        query: query,
        timeout: 120,
        #debug_output: $stdout
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

    def points
      r = []
      @res['data'].each do |blob|
        next if blob['type'] == 'price'
        raise blob['units'] unless blob['units'] == 'MW'
        type = FUEL_MAP[blob['fuel_tech']]
        raise blob['fuel_tech'] if type.nil?
        start = DateTime.strptime(blob['history']['start'], '%Y-%m-%dT%H:%M:%S%:z')
        interval = parse_interval(blob['history']['interval'])

        #require 'pry' ; binding.pry
        blob['history']['data'].each_with_index do |value,index|
          time = start + interval * index

          if blob['fuel_tech'] == 'battery_charging' || blob['fuel_tech'] == 'pumps'
            value = -value
          end
          r << {
            time: time,
            production_type: type,
            country: @country,
            value: value.to_f
          }
        end
      end

      @logger.info("#{r.length} points")
      r
    end
  end
end
