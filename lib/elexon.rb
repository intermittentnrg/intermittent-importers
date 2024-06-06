# coding: utf-8
require 'faraday/retry'
require 'faraday/net_http_persistent'
require 'fastest_csv'
require 'chronic'
require 'business_time'

module Elexon
  class Base
    TZ = TZInfo::Timezone.get('UTC')
    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      # f.request :retry, {
      #             retry_statuses: [404, 500, 502, 504],
      #             interval: 2,
      #             backoff_factor: 2,
      #             max: 5
      #           }
      # f.response :logger, Logger.new($stderr)
    end

    def self.source_id
      "elexon"
    end

    DATE_FORMAT = '%Y-%m-%d'
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%SZ'
  end

  class BaseCSV < Base
    def initialize(date_or_io)
      if date_or_io.is_a? Date
        date = date_or_io
        @options = {}
        @options[:format] = 'csv'
      else
        @csv = FastestCSV.read(date_or_io, row_sep: "\r\n")
      end
    end

    def fetch
      return if @csv

      logger.benchmark_info(@url) do
        res = @@faraday.get(@url, @options)
        @csv = FastestCSV.parse(res.body, row_sep: "\r\n")
      end
    end
  end

  # https://bmrs.elexon.co.uk/api-documentation/endpoint/datasets/FUELINST
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
      super(from_or_path)
      @from = from_or_path
      @to = to || @from + 1.day
      @url = "https://data.elexon.co.uk/bmrs/api/v1/datasets/FUELINST"
      @options[:settlementDateFrom] = @from.strftime('%Y-%m-%d')
      @options[:settlementDateTo] = @to.strftime('%Y-%m-%d')
    end

    FUEL_MAP = {
      'BIOMASS' => 'biomass',
      'CCGT' => 'fossil_gas_ccgt',
      'COAL' => 'fossil_hard_coal',
      'NPSHYD' => 'hydro',
      'NUCLEAR' => 'nuclear',
      'OCGT' => 'fossil_gas_ocgt',
      'OIL' => 'fossil_oil',
      'OTHER' => 'other',
      'PS' => 'hydro_pumped_storage',
      'WIND' => 'wind'
    }
    TRAN_MAP = {
      'INTELE' => 'FR',
      'INTELEC' => 'FR',
      'INTEW' => 'IE',
      'INTFR' => 'FR',
      'INTGRNL' => 'IE',
      'INTIFA2' => 'FR',
      'INTIRL' => 'IE',
      'INTNED' => 'NL',
      'INTNEM' => 'BE',
      'INTNSL' => 'NO',
      'INTVKL' => 'DK'
    }
    def process
      r_gen = []
      r_tran = {}
      fetch
      @csv.each do |row|
        #0 Dataset
        next unless row[0] == 'FUELINST'
        #1 PublishTime
        #2 StartTime
        time = Time.strptime(row[2], TIME_FORMAT)
        #3 SettlementDate
        #4 SettlementPeriod
        #5 FuelType
        #6 Generation
        value = row[6].to_i*1000

        if production_type = FUEL_MAP[row[5]]
          r_gen << {country: 'GB', time:, value:, production_type: FUEL_MAP[row[5]]}
        elsif to_area = TRAN_MAP[row[5]]
          k = [time,to_area]
          r_tran[k] ||= {time:, from_area: 'GB', to_area:, value: 0}
          r_tran[k][:value] += value
        else
          raise row.inspect
        end
      end

      r_gen = Validate.validate_generation(r_gen, self.class.source_id)
      Out2::Generation.run(r_gen, @from, @to, self.class.source_id)
      Out2::Transmission.run(r_tran.values, @from, @to, self.class.source_id)
    end
  end

  # https://bmrs.elexon.co.uk/api-documentation/endpoint/datasets/AGPT
  class Generation < BaseCSV
    include SemanticLogger::Loggable
    include Out::Generation

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |date|
        e = Elexon::Generation.new(date)
        e.process
      end
    end

    DATETIME_FORMAT = '%Y-%m-%d %H:%M'
    def initialize(date)
      super
      @url = 'https://data.elexon.co.uk/bmrs/api/v1/datasets/AGPT'
      @from = date
      @to = date + 1.day
      @options[:publishDateTimeFrom] = @from.strftime(DATETIME_FORMAT)
      @options[:publishDateTimeTo] = @to.strftime(DATETIME_FORMAT)
    end
    def points_generation
      r = {}
      fetch
      @csv.each do |row|
        #0 Dataset
        next unless row[0] == 'AGPT'
        #1 DocumentId
        #2 DocumentRevisionNumber
        #3 PublishTime
        #4 BusinessType
        #5 PsrType
        production_type = row[5].downcase.tr_s(' ', '_')
        #6 Quantity
        value = row[6].to_f*1000
        #7 StartTime
        time = Time.strptime(row[7], TIME_FORMAT)
        #8 SettlementDate
        #9 SettlementPeriod
        k=[time,production_type]
        r[k] ||= {country: 'GB_B1620', production_type:, time:, value:}
      end

      Validate.validate_generation(r.values, self.class.source_id)
    end
  end

  # https://bmrs.elexon.co.uk/api-documentation/endpoint/demand/actual/total
  # https://bmrs.elexon.co.uk/api-documentation/endpoint/datasets/ATL
  # maximum data output range of 7 days
  class Load < BaseCSV
    include SemanticLogger::Loggable
    include Out::Load

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).each do |time|
        e = Elexon::Load.new(time)
        e.process
      end
    end

    def initialize(date)
      super
      @url = 'https://data.elexon.co.uk/bmrs/api/v1/demand/actual/total'
      @options[:from] = date.strftime(DATE_FORMAT)
      @options[:to] = (date + 1.day).strftime(DATE_FORMAT)
    end
    def points_load
      r = {}
      fetch
      @csv.shift #skip header
      @csv.each do |row|
        #0 PublishTime
        #1 StartTime
        time = Time.strptime(row[1], TIME_FORMAT)
        #2 SettlementDate
        #3 SettlementPeriod
        #4 Quantity
        value = (row[4].to_f*1000).to_i
        r[time] ||= {time:, country: 'GB', value:}
      end
      #require 'pry' ; binding.pry
      Validate.validate_load(r.values, self.class.source_id)
    end
  end

  # https://bmrs.elexon.co.uk/api-documentation/endpoint/datasets/B1610
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

      (from...to).each do |date|
        begin
          (1..50).each do |period|
            Elexon::Unit.new(date, period).process
          end
        rescue EmptyError
          logger.warn "EmptyError #{time}"
        end
      end
    end

    def self.each
      from =::GenerationUnit.joins(:unit => :area).where("area.source" => self.source_id).where("time > ?", 2.months.ago).maximum(:time)
      from = from.to_date
      (from..5.business_days.ago).each do |date|
        (1..50).each do |period|
          yield self.new(date, period)
        end
      rescue EmptyError
        logger.warn "Empty response #{date}"
      end
    end

    def initialize(date, period)
      super(date)
      @from = date
      @to = date.tomorrow
      @url = 'https://data.elexon.co.uk/bmrs/api/v1/datasets/B1610'
      @options[:settlementDate] = date.strftime('%Y-%m-%d')
      @options[:settlementPeriod] = period
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
        #0 Dataset
        next unless row[0] == 'B1610'
        #1 PsrType
        next unless row[1] == 'Generation'
        #2 BmUnit
        next unless row[3]
        unit_internal_id = row[3]
        unit = @@units[unit_internal_id] ||= area.units.
                                               create_with(production_type_id: default_production_type_id).
                                               find_or_create_by(internal_id: unit_internal_id)
        #3 NationalGridBmUnitId
        #4 SettlementDate
        #5 SettlementPeriod
        #6 HalfHourEndTime
        time = (Time.strptime("#{row[4]} UTC", '%Y-%m-%d %Z') + (row[5].to_i * 30).minutes)
        #7 Quantity
        value = row[7].to_f*1000*2

        k = [unit.id, time]
        if r[k] && r[k][:value] != value
          require 'pry' ; binding.pry
        end
        r[k] = {unit_id: unit.id, time:, value:}
      end
      #binding.irb

      r.values
    end

    def process
      Out2::Unit.run(points, @from, @to, self.class.source_id)
    end
  end

  # https://bmrs.elexon.co.uk/api-documentation/endpoint/datasets/IGCA
  class Capacity < BaseCSV
    include SemanticLogger::Loggable
    include CliMixin::Yearly

    def initialize(date)
      @url = 'https://data.elexon.co.uk/bmrs/api/v1/datasets/IGCA'
      @from = date
      @to = date + 1.year
      super
    end

    def points_capacity
      area = Area.find_by(code: 'GB_B1620', source: 'elexon')
      area_id = area.id

      fetch
      5.times { @csv.shift }
      r = []
      @csv.each do |row|
        #0:Document Type
        next unless row[0] == 'Installed generation per type'

        #1:Business Type
        next unless row[1] == 'Installed generation'

        #2:Process Type
        next unless row[2] == 'Year ahead'

        #3:Time Series ID
        #4:Quantity
        value = row[4].to_f*1000

        #5:Resolution
        next unless row[5] == 'P1Y'

        #6:Year
        time = Time.strptime(row[6], '%Y')

        #7:Power System Resource  Type
        production_type = row[7].gsub(/ /,'_').downcase
        # missing/no generation data:
        next if production_type == 'other_renewable'

        #8:Active Flag
        unless row[8] == 'Y'
          require 'pry' ; binding.pry
        end
        #9:Document ID
        #10:Document RevNum

        r << {area_id:, production_type:, time:, value:}
      end
      require 'pry' ; binding.pry

      r
    end

    def process
      Out2::Capacity.run(points_capacity, nil, nil, self.class.source_id)
    end
  end

  # https://bmrs.elexon.co.uk/api-documentation/endpoint/datasets/IGCPU
  class UnitCapacity < BaseCSV
    include SemanticLogger::Loggable
    include CliMixin::Yearly

    def initialize(date)
      @url = 'https://data.elexon.co.uk/bmrs/api/v1/datasets/IGCPU'
      super
    end

    def points_unit_capacity
      area = Area.find_by(code: 'GB', source: 'elexon')

      fetch
      @csv.shift
      r = {}
      #r = []
      @csv.each do |row|
        #Document Type
        next unless row[0] == 'Configuration document'

        #Business Type
        next unless row[1] == 'Production unit'

        #Process Type
        #Time Series ID
        #Power System Resource Type
        production_type_name = row[4].gsub(/ /,'_').downcase

        #Year
        #time = Time.strptime(row[5], '%Y')

        #BM Unit ID
        #Registered Resource EIC Code
        #Voltage limit
        #9:Nominal
        value = row[9].to_f*1000

        #10:NGC BM Unit ID
        next if row[10] == 'NA'
        unit = area.units.find_by(internal_id: row[10])
        unless unit
          production_type = ProductionType.find_by! name: production_type_name
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
        #12:Active Flag
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

  # https://bmrs.elexon.co.uk/api-documentation/endpoint/temperature
  class Temperature < BaseCSV
    def initialize
      super
      @url = 'https://data.elexon.co.uk/bmrs/api/v1/temperature'
      @options[:from] = date.strftime(DATE_FORMAT)
      @options[:to] = (date + 1.day).strftime(DATE_FORMAT)
    end
  end
end
