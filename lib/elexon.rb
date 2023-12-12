# coding: utf-8
require 'faraday/retry'
require 'faraday/net_http_persistent'
require 'ox'
require 'csv'
require 'chronic'

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
      raise EmptyError if error_type == 'No Content'
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

  class Interfuelhh < BaseCSV
    include SemanticLogger::Loggable
    include Out::Transmission

    def self.cli(args)
      if args.length == 1 && args.first.include?('.')
        self.new(args.first).process
      elsif args.length < 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      else
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date

        (from...to).each do |time|
          e = self.new(time)
          e.process
        rescue EmptyError
          logger.warn "EmptyError #{time}"
        end
      end
    end
    def self.parsers_each
      from = Transmission \
               .joins(:from_area) \
               #.joins('INNER JOIN "areas" "to_area" ON "to_area"."id" = "transmission"."to_area_id"') \
               .where(from_area: {source: self.source_id}) \
               .where("time > ?", 12.months.ago) \
               .maximum(:time).to_date
      (from..Date.today).each do |date|
        yield self.new date
      rescue EmptyError
        logger.warn "Empty response #{date}"
      end
    end
    def initialize(from)
      @from = from
      @to = from + 1.day
      @report = 'INTERFUELHH'
      @options = {}
      @options[:FromDate] = @from.strftime('%Y-%m-%d')
      @options[:ToDate] = @to.strftime('%Y-%m-%d')
      @options[:ServiceType] = 'csv'
      @options[:APIKey] = ENV['ELEXON_TOKEN']
    end

    def points
      area_gb = Area.where(source: self.class.source_id, code: 'GB').pluck(:id).first

      area_be = Area.where(source: self.class.source_id, code: 'BE').pluck(:id).first
      area_dk = Area.where(source: self.class.source_id, code: 'DK').pluck(:id).first
      area_fr = Area.where(source: self.class.source_id, code: 'FR').pluck(:id).first
      area_ie = Area.where(source: self.class.source_id, code: 'IE').pluck(:id).first
      area_nl = Area.where(source: self.class.source_id, code: 'NL').pluck(:id).first
      area_no = Area.where(source: self.class.source_id, code: 'NO').pluck(:id).first

      fetch
      r_trans_all = {}
      @csv.each do |row|
        # 0:Record Type
        next unless row[0] == 'INTOUTHH'
        r_trans = []
        # 1:Settlement Date
        date = Time.strptime(row[1], '%Y%m%d')
        # 2:Settlement Period
        time = date + (row[2].to_i - 1) * 30.minutes
        # 3:INTFR - External Interconnector flows with France
        r_trans << {time:, from_area_id: area_gb, to_area_id: area_fr, value: row[3].to_f*1000 + row[8].to_f*1000 + row[9].to_f*1000}
        # 4:INTIRL - External Interconnector flows with Ireland
        r_trans << {time:, from_area_id: area_gb, to_area_id: area_ie, value: row[4].to_f*1000 + row[6].to_f*1000}
        # 5:INTNED - External Interconnector flows with the Netherlands
        r_trans << {time:, from_area_id: area_gb, to_area_id: area_nl, value: row[5].to_f*1000}
        # 6:INTEW - External Interconnector flows with Ireland (East-West)
        # 7:INTNEM – External Interconnector flows with Belgium (Nemo Link)
        r_trans << {time:, from_area_id: area_gb, to_area_id: area_be, value: row[7].to_f*1000}
        # 8:INTELEC – External Interconnector flows with France (ElecLink)
        # 9:INTIFA2 – External Interconnector flows with France (IFA2)
        # 10:INTNSL – External Interconnector flows with Norway 2 (North Sea Link)
        r_trans << {time:, from_area_id: area_gb, to_area_id: area_no, value: row[10].to_f*1000}
        # 11:INTVKL – External Interconnector flows with Denmark 1 (Viking Link)
        r_trans << {time:, from_area_id: area_gb, to_area_id: area_dk, value: row[11].to_f*1000}

        r_trans_all[time] = r_trans
      end
      #require 'pry' ; binding.pry

      r_trans_all.values.flatten
    end
  end

  class Fuelinst < BaseCSV
    include SemanticLogger::Loggable
    include Out::Generation

    def self.cli(args)
      if args.length == 1 && args.first.include?('.')
        self.new(args.first).process
      elsif args.length < 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      else
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date

        (from...to).each do |time|
          e = self.new(time, time + 1.day)
          e.process
        rescue EmptyError
          logger.warn "EmptyError #{time}"
        end
      end
    end

    def initialize(from_or_path, to = nil)
      if from_or_path.is_a? String
        @res = Ox.load_file(from_or_path, mode: :hash, symbolize_keys: false)
      else
        @from = from_or_path
        @to = to || @from + 1.day
        @report = 'FUELINST'
        @options = {}
        @options[:FromDateTime] = @from.strftime('%Y-%m-%d %H:%M:%S')
        @options[:ToDateTime] = @to.strftime('%Y-%m-%d %H:%M:%S')
        @options[:Period] = "*"
        @options[:ServiceType] = 'csv'
        @options[:APIKey] = ENV['ELEXON_TOKEN']
        fetch
      end
    end

    def points_generation
      r_all = {}
      @csv.each do |row|
        # Record Type
        next unless row[0] == 'FUELINST'
        # Settlement Date
        # Settlement Period
        # Spot Time
        unless row[3]
          require 'pry' ; binding.pry
        end
        time = Time.strptime(row[3], '%Y%m%d%H%M%S')
        r = []
        # CCGT
        r << {time:, country: 'GB', production_type: 'fossil_gas_ccgt', value: row[4].to_f*1000}
        # OIL
        r << {time:, country: 'GB', production_type: 'fossil_oil', value: row[5].to_f*1000}
        # COAL
        r << {time:, country: 'GB', production_type: 'fossil_hard_coal', value: row[6].to_f*1000}
        # NUCLEAR
        r << {time:, country: 'GB', production_type: 'nuclear', value: row[7].to_f*1000}
        # WIND
        r << {time:, country: 'GB', production_type: 'wind', value: row[8].to_f*1000}
        # PS
        r << {time:, country: 'GB', production_type: 'hydro_pumped_storage', value: row[9].to_f*1000}
        # NPSHYD
        r << {time:, country: 'GB', production_type: 'hydro', value: row[10].to_f*1000}
        # OCGT
        r << {time:, country: 'GB', production_type: 'fossil_gas_ocgt', value: row[11].to_f*1000}
        # OTHER
        r << {time:, country: 'GB', production_type: 'other', value: row[12].to_f*1000}
        # INTFR
        # INTIRL
        # INTNED
        # INTEW
        # BIOMASS
        r << {time:, country: 'GB', production_type: 'biomass', value: row[17].to_f*1000}
        # INTNEM
        # INTELEC
        # INTIFA2
        # INTNSL
        r_all[time] = r
      end
      #require 'pry'; binding.pry

      Validate.validate_generation(r_all.values.flatten, self.class.source_id)
    end
  end

  class Generation < BaseXML
    include SemanticLogger::Loggable
    include Out::Generation

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = Elexon::Generation.new(time)
        e.process
      end
    end

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

      Validate.validate_generation(r.values, self.class.source_id)
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

      Validate.validate_load(r.values, self.class.source_id)
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
      rescue EmptyError
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
        if r[k] && r[k][:value] != value
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
