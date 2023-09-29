# coding: utf-8
require 'faraday/retry'
require 'faraday/net_http_persistent'

module Elexon
  class Base
    TZ = TZInfo::Timezone.get('UTC')
    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      f.request :retry, {
                  retry_statuses: [404, 500, 502, 504],
                  interval: 2,
                  backoff_factor: 2,
                  max: 5
                }
    end

    def self.source_id
      "elexon"
    end
    def self.api_version
      "v1"
    end
  end

  class BaseXML < Base
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
      @res = logger.benchmark_info(url) do
        res = @@faraday.get(url, @options)
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

  class BaseCSV < Base
    def initialize(date_or_io)
      @report = 'B1420'
      #@from = date + 30.minutes
      #@to = date.tomorrow + 30.minutes
      #super
      if date_or_io.is_a? Date
        date = date_or_io
        @options = {}
        #@options[:ServiceType] = 'xml'
        @options[:ServiceType] = 'csv'
        @options[:APIKey] = ENV['ELEXON_TOKEN']
        @options[:Year] = date.strftime('%Y')
      else
        @csv = CSV.new(date_or_io, liberal_parsing: true)
      end
    end
    def fetch
      return if @csv

      url = "https://api.bmreports.com/BMRS/#{@report}/#{self.class.api_version}"
      logger.benchmark_info("#{url} #{@options[:Year]}") do
        res = @@faraday.get(url, @options)
        @csv = CSV.new(res.body, liberal_parsing: true)
      end
    end
  end

  class Fuelinst < BaseXML
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
            value: (item[k].to_f*1000).to_i
          }
        end
      end
      #require 'pry' ; binding.pry

      r.values.flatten
    end
  end

  class Generation < BaseXML
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
          value: (item['quantity'].to_f*1000).to_i
        }
      end

      r.values
    end
  end

  class Load < BaseXML
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
        value = (item['quantity'].to_f*1000).to_i
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

  class Unit < BaseCSV
    include SemanticLogger::Loggable
    include Out::Unit

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = Elexon::Unit.new(time)
        e.process
      rescue ENTSOE::EmptyError
        logger.warn "EmptyError #{time}"
      end
    end

    def self.api_version
      "v2"
    end
    def self.refresh_to
      require 'business_time'
      5.business_days.ago
    end

    def initialize(date)
      @from = date + 30.minutes
      @to = date.tomorrow + 30.minutes
      @report = 'B1610'
      @options = {}
      @options[:ServiceType] = 'csv'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
      @options[:Period] = '*'
      @options[:SettlementDate] = date.strftime('%Y-%m-%d')
      #@options[:NGCBMUnitID] = unit
    end

    @@units = {}
    def self.clear_cache!
      @@units = {}
    end
    def points
      fetch
      #require 'pry' ; binding.pry
      area = Area.find_by(code: 'GB', source: 'elexon')
      default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first
      r = {}
      @csv.each do |row|
        # Time Series ID
        # Registered Resource  EIC Code
        # BM Unit ID
        # NGC BM Unit ID
        next if row[3] == 'NA'
        unit_internal_id = row[3]
        unit = @@units[unit_internal_id] ||= area.units.
                                               create_with(production_type_id: default_production_type_id).
                                               find_or_create_by(internal_id: unit_internal_id)
        # PSR Type
        next unless row[4] == 'Generation'
        # Market Generation Unit EIC Code
        # Market Generation BMU ID
        # Market Generation NGC BM Unit ID
        # Settlement Date
        time = Time.parse(row[8], '%Y-%m-%d')
        # SP
        time += row[9].to_i * 30.minutes
        # Quantity (MW)
        value = row[10].to_f * 1000
        k = [unit.id, time]
        if r[k]
          require 'pry' ; binding.pry
        end
        r[k] = {unit_id: unit.id, time:, value:}
      end

      r.values
    end

    def process
      Out2::Unit.run(points, @from, @to, self.class.source_id)
    end
  end

  class UnitCapacity < BaseCSV
    include SemanticLogger::Loggable
    def self.cli(args)
      if args.length == 1
        from = Chronic.parse(args[0])
        if from
          self.new(from.to_date).process
        else
          self.new(File.open(args[0], 'r')).process
        end
      elsif args.length == 2
        from = Chronic.parse(args[0]).to_date
        to = Chronic.parse(args[1]).to_date
        (from...to).select { |d| d.month==1 && d.day==1 }.each do |year|
          self.new(year).process
        end
      else
        self.new(Date.today).process
      end
    end

    def points_unit_capacity
      area = Area.find_by(code: 'GB', source: 'elexon')

      fetch
      @csv.shift
      r = {}
      #r = []
      @csv.each do |row|
        #*Document Type
        next unless row[0] == 'Configuration document'

        #Business Type
        next unless row[1] == 'Production unit'

        #Process Type
        #Time Series ID
        #Power System Resource  Type
        production_type_name = row[4].gsub(/ /,'_').downcase

        #Year
        #time = Time.strptime(row[5], '%Y')

        #BM Unit ID
        #Registered Resource EIC Code
        #Voltage limit
        #Nominal
        value = row[9].to_f*1000

        #NGC BM Unit ID
        next if row[10] == 'NA'
        unit = area.units.find_by(internal_id: row[10])
        unless unit
          production_type = ProductionType.find_by name: production_type_name
          unless production_type
            logger.warn "Unknown production_type: #{production_type_name}"
            next
          end

          logger.info "New #{production_type_name} unit #{row[10]}"
          unit = area.units.create!(internal_id: row[10], production_type:)
          #require 'pry' ; binding.pry
        end
        if production_type_name != 'generation' && unit.production_type.name != production_type_name
          production_type = ProductionType.find_by name: production_type_name
          unit.production_type = production_type
          unit.save!
          puts "#{unit.name} #{unit.internal_id} current=#{unit.production_type.name} != api=#{production_type_name}"
        end
        #next unless unit
        #create_with(production_type_id: default_production_type_id).

        #Registered Resource Name
        #Active Flag
        unless row[12] == 'Y'
          require 'pry' ; binding.pry
        end

        #Document ID
        #Implementation Date
        time = Time.strptime(row[14], '%Y-%m-%d')

        #Decommissioning Date
        k = [unit.id, time]
        if r[k]
          require 'pry' ; binding.pry
        end
        r[k] = {unit_id: unit.id, time:, value:}
      end
      #require 'pry' ; binding.pry

      r.values
    end
    def process
      Out2::UnitCapacity.run(points_unit_capacity, nil, nil, self.class.source_id)
    end
  end
end
