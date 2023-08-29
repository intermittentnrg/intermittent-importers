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
      return if @gen_r

      @load_r = []
      @gen_r = []
      @price_r = []
      @res['data'].each do |blob|
        next if blob['type'] == 'temperature'
        next if blob['type'].starts_with? 'emissions'
        next if blob['code'].include? '>'
        next if blob['code'] == 'imports' || blob['code'] == 'exports'
        raise blob['units'] unless ['MW', 'AUD/MWh'].include?(blob['units'])
        country = "#{blob['network']}-#{blob['region']}".upcase
        country = "WEM-WEM" if blob['network'] == 'WEM'
        start = Time.strptime(blob['history']['start'], '%Y-%m-%dT%H:%M:%S%:z')
        interval = parse_interval(blob['history']['interval'])

        if blob['code'] == 'demand'
          blob['history']['data'].each_with_index do |value,index|
            time = start + interval * index
            @load_r << {
              time: time,
              country: country,
              value: value*1000
            }
          end
        elsif blob['type'] == 'price'
          blob['history']['data'].each_with_index do |value,index|
            time = start + interval * index
            @price_r << {
              time:,
              country:,
              value: value
            }
          end
          #require 'pry' ; binding.pry
        else
          type = FUEL_MAP[blob['fuel_tech']]
          require 'pry' ; binding.pry if type.nil?
          raise blob['fuel_tech'] if type.nil?

          blob['history']['data'].each_with_index do |value,index|
            time = start + interval * index
            next if value.nil?

            if blob['fuel_tech'] == 'battery_charging' || blob['fuel_tech'] == 'pumps'
              value = -value
            end
            @gen_r << {
              time: time,
              production_type: type,
              country: country,
              value: (value.to_f*1000).to_i
            }
          end
        end
      end

      #require 'pry' ; binding.pry
    end
    def points_generation
      points
      logger.info("#{@gen_r.length} points")

      @gen_r
    end
    def points_load
      points
      logger.info("#{@load_r.length} points")

      @load_r
    end
    def points_price
      points
      logger.info("#{@gen_r.length} points")

      @price_r
    end
  end

  class Month < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(country: nil, date: nil)
      @from = date
      @to = date + 1.month
      network, region = country.split(/-/)
      query = {
        month: date.strftime('%Y-%m-%d')
      }
      url = "https://api.opennem.org.au/stats/power/network/fueltech/#{network}/#{region}"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: query,
          timeout: 180,
          #debug_output: $stdout
        )
      end
    end
  end

  class Price < Base
    def initialize(country: nil, date: nil)
      @from = date
      @to = date + 1.month
      network, region = country.split(/-/)
      query = {
        month: date.strftime('%Y-%m-%d')
      }
      url = "https://api.opennem.org.au/stats/price/#{network}/#{region}"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: query,
          timeout: 180,
          #debug_output: $stdout
        )
      end
    end
  end

  # 5 minute resolution
  class Week < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(country: nil, date: nil)
      @from = date.beginning_of_week
      @to = @from + 1.week
      network, region = country.split(/-/)
      url = "https://data.opennem.org.au/v3/stats/historic/weekly/#{network}/#{region}/year/#{date.strftime('%Y')}/week/#{date.strftime('%U').to_i + 1}.json"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          timeout: 180,
          #debug_output: $stdout
        )
      end
    end
  end

  #includes generation, price
  #missing demand
  class Latest < Base
    include SemanticLogger::Loggable
    include Out::Generation
    include Out::Price

    def initialize
      url = "https://data.opennem.org.au/v3/clients/em/latest.json"
      @res = logger.benchmark_info(url) do
        HTTParty.get(url)
      end
      @from = @res['data'][0]['history']['start']
      @to = @res['data'][0]['history']['last']
    end
  end

  # NOTE: Missing WEM-WEM data
  class LatestWeek < Base
    include SemanticLogger::Loggable
    include Out::Load
    include Out::Generation

    def initialize(country)
      network, region = country.split(/-/)
      url = "https://data.opennem.org.au/v3/stats/au/#{network}/#{region}/power/7d.json"
      @res = logger.benchmark_info(url) do
        HTTParty.get(url)
      end
      @from = @res['data'][0]['history']['start']
      @to = @res['data'][0]['history']['last']
    end
    def process
      process_load
      process_generation
    end
  end
end
