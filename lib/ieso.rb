require 'faraday/net_http_persistent'
require 'faraday/gzip'

module Ieso
  HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'

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

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      f.request :gzip
      #f.response :logger #, logger
    end

    def fetch
      @filedate = DataFile.where(path: File.basename(@url), source: self.class.source_id).pluck(:updated_at).first
      @res = logger.benchmark_info(@url) do
        @@faraday.get(@url) do |req|
          if @filedate
            req.headers['If-Modified-Since'] = @filedate.strftime(HTTP_DATE_FORMAT)
          end
        end
      end
      if @res.status == 304
        raise ENTSOE::EmptyError
      end
      @filedate = Time.strptime(@res.headers['Last-Modified'], HTTP_DATE_FORMAT)
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

    def done!
      DataFile.upsert({path: File.basename(@url), source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{File.basename(@url)}"
    end
  end

  class Load < Base
    include SemanticLogger::Loggable
    include Out::Load

    def initialize(date)
      @from = date.beginning_of_year
      @to = date.end_of_year

      @url = "http://reports.ieso.ca/public/Demand/PUB_Demand_#{date.strftime('%Y')}.csv"
      fetch
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
      @url = "http://reports.ieso.ca/public/GenOutputCapabilityMonth/PUB_GenOutputCapabilityMonth_#{date.strftime('%Y%m')}.csv"
      fetch
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

      @url = "http://reports.ieso.ca/public/GenOutputCapability/PUB_GenOutputCapability_#{date.strftime('%Y%m%d')}.xml"
      fetch
    end
    def fuel_sums
      doc = @res.parsed_response["IMODocument"]["IMODocBody"]
      date = Time.strptime(doc["Date"], '%Y-%m-%d')
      fuel_sums = {}
      doc["Generators"]["Generator"].each do |g|
        # TODO: populate generation_unit and aggregate to generation
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

  class Price < Base
    include SemanticLogger::Loggable
    include Out::Price

    def initialize(date)
      @from = date
      @to = date + 1.day

      @url = "http://reports.ieso.ca/public/DispUnconsHOEP/PUB_DispUnconsHOEP_#{date.strftime('%Y%m%d')}.csv"
      fetch
    end

    def points_price
      r = []
      base_time = TZ.local_to_utc(@from.to_time)
      CSV.parse(@res.body, skip_lines: /^(?!\s*\d)/, headers: false) do |row|
        time = base_time + row[0].to_i.hours
        r << {
          time:,
          value: row[1].to_f,
          country: 'CA-ON'
        }
      end

      r
    end
  end
  class PriceYear < Base
    include SemanticLogger::Loggable
    include Out::Price

    def initialize(date)
      @from = date.beginning_of_year
      @to = date.end_of_year
      @url = "http://reports.ieso.ca/public/PriceHOEPPredispOR/PUB_PriceHOEPPredispOR_#{date.strftime('%Y')}.csv"
      fetch
    end

    def points_price
      r = []
      CSV.parse(@res.body, skip_lines: /^(?!\s*\d)/, headers: false) do |row|
        time = Time.strptime("#{row[0]} #{row[1]}", '%Y-%m-%d %H')
        time = TZ.local_to_utc(time)
        value = row[2].to_f
        r << {
          time:,
          value:,
          country: 'CA-ON'
        }
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
