# coding: utf-8
require 'active_support'
require 'active_support/core_ext'
require 'faraday/retry'

module Elexon
  class Base
    def self.source_id
      "elexon"
    end
    def self.api_version
      "v1"
    end
    def initialize(date)
      @from = date + 30.minutes
      @to = date.tomorrow + 30.minutes
      @options = {}
      @options[:ServiceType] = 'xml'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
      @options[:Period] = '*'
      @options[:SettlementDate] = date.strftime('%Y-%m-%d')
      fetch
    end
    def fetch
      url = "https://api.bmreports.com/BMRS/#{@report}/#{self.class.api_version}"
      faraday = Faraday.new do |f|
        f.request :retry, {
          retry_statuses: [404, 500, 502],
          max: 2
        }
      end
      @res = logger.benchmark_info(url) do
        res = faraday.get(url, @options)
        Ox.load(res.body, mode: :hash, symbolize_keys: false)
      rescue
        logger.error "Failed to parse body: #{res.body}"
        raise
      end
      error_type = @res['response']['responseMetadata']['errorType']
      raise ENTSOE::EmptyError if error_type == 'No Content'
      binding.pry unless @res['response'].try(:[], 'responseBody')
      raise error_type if @res['response'].try(:[], 'responseBody').empty?
    end
  end

  class Fuelinst < Base
    include SemanticLogger::Loggable
    include Out::Generation

    MAP = {
      "ccgt" => "fossil_gas_ccgt",
      "oil" => "fossil_oil",
      "coal" => "fossil_hard_coal",
      "nuclear" => "nuclear",
      "wind" => "wind",
      "ps" => "solar",
      "npshyd" => "hydro",
      "ocgt" => "fossil_gas_ocgt",
      "other" => "other",
      "biomass" => "biomass"
    }
    def initialize(from, to = nil)
      to = from + 1.day unless to
      @from = from
      @to = to
      @report = 'FUELINST'
      @options = {}
      @options[:FromDateTime] = from.strftime('%Y-%m-%d %H:%M:%S')
      @options[:ToDateTime] = to.strftime('%Y-%m-%d %H:%M:%S')
      @options[:Period] = "*"
      @options[:ServiceType] = 'xml'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
      fetch
    end
    def points_generation
      r = {}
      @res['response']['responseBody']['responseList']['item'].each do |item|
        time = (Time.strptime("#{item['startTimeOfHalfHrPeriod']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes)

        r[time] = r2 = []
        MAP.each do |k,v|
          r2 << {
            country: 'GB',
            production_type: v,
            time: time,
            value: item[k].to_f.round
          }
        end
      end
      #require 'pry' ; binding.pry

      r.values.flatten
    end
  end

  class WindSolar < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @report = 'B1630'
      super
    end
    def points
      r = {}
      @res['response']['responseBody']['responseList']['item'].each do |item|
        time = (Time.strptime("#{item['settlementDate']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes)
        production_type = item['powerSystemResourceType'].gsub(/"/,'').downcase.tr_s(' ', '_')
        key = "#{time}-#{production_type}"
        next if r[key]
        r[key] = {
          country: 'GB_B1630',
          production_type: production_type,
          time: time,
          value: item['quantity'].to_f.round
        }
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end

  class Generation < Base
    include SemanticLogger::Loggable
    include Out::Generation

    def initialize(date)
      @report = 'B1620'
      super
    end
    def points_generation
      r = {}
      @res['response']['responseBody']['responseList']['item'].each do |item|
        time = (Time.strptime("#{item['settlementDate']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes)
        production_type = item['powerSystemResourceType'].gsub(/"/,'').downcase.tr_s(' ', '_')
        key = "#{time}-#{production_type}"
        next if r[key]
        r[key] = {
          country: 'GB_B1620',
          production_type: production_type,
          time: time,
          value: item['quantity'].to_f.round
        }
      end

      r.values
    end
  end

  class Load < Base
    include SemanticLogger::Loggable
    include Out::Load

    def initialize(date)
      @report = 'B0610'
      super
    end
    def points_load
      r = {}
      @res['response']['responseBody']['responseList']['item'].each do |item|
        time = Time.strptime("#{item['settlementDate']} UTC", '%Y-%m-%d %Z') + (item['settlementPeriod'].to_i * 30).minutes
        value = item['quantity'].to_f.round
        next if value < 10000
        next if r[time]

        r[time] = {
          time: time,
          country: 'GB',
          value: value
        }
      end
      #r.filter! { |r2| r2[:value] > 10000 }
      #require 'pry' ; binding.pry

      r.values
    end
  end

  class Unit < Base
    include SemanticLogger::Loggable
    #include Out::Load

    def self.api_version
      "v2"
    end
    #def initialize()
    #  @report = 'B1610'
    #  super
    #end
    def initialize(date, unit)
      @from = date + 30.minutes
      @to = date.tomorrow + 30.minutes
      @unit = unit
      @report = 'B1610'
      @options = {}
      @options[:ServiceType] = 'xml'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
      @options[:Period] = '*'
      @options[:SettlementDate] = date.strftime('%Y-%m-%d')
      @options[:NGCBMUnitID] = unit
      fetch
    end

    def points
      item = @res['response']['responseBody']['responseList']['item']
      start = Time.strptime("#{item['settlementDate']} UTC", '%Y-%m-%d %Z')
      r = {}
      #require 'pry' ; binding.pry
      Array.wrap(item["Period"]["Point"]).each do |point|
        period = point['settlementPeriod'].to_i
        next if r[period]
        r[period] = {
          time: start + (period * 30.minutes),
          value: (point['quantity'].to_f*1000).to_i
        }
      end
      #require 'pry' ; binding.pry

      r.values
    end

    def process
      data = points
      area = Area.where(source: self.class.source_id, code: 'GB').first
      unit = ::Unit.find_or_create_by(area_id: area.id, internal_id: @unit)
      data.each do |p|
        p[:unit_id] = unit.id
      end
      logger.info "#{data.first.try(:[], :time)} #{data.length} points"
      #require 'pry' ; binding.pry
      ::GenerationUnit.upsert_all(data)
    end
  end
end
