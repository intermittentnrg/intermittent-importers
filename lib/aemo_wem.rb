require 'chronic'
require 'fast_jsonparser'

module AemoWem
  class Base < ::Aemo::Base
    TZ = TZInfo::Timezone.get('Etc/GMT-8')
    URL_BASE = "https://data.wa.aemo.com.au"
    INDEX_TIME_FORMAT = "%m/%d/%Y %I:%M %p"

    def self.cli(args)
      if args.length == 2
        from = Chronic.parse(args.shift).to_date
        to = Chronic.parse(args.shift).to_date
        cli_range(from...to).each do |date|
          self.new(date).process
        end
      elsif args.present?
        args.each do |path|
          self.new(path).process
        end
      else
        self.each &:process
      end
    end

    def self.cli_range(range)
      range.select { |d| d.month==1 && d.day==1 }
    end

    def self.select_file? url
      url =~ /.csv$/i
    end

    def initialize(file_or_date)
      if file_or_date.is_a? Date
        super(file_or_date.strftime(self.class::URL_FORMAT))
      elsif file_or_date =~ /^https?:/
        super(file_or_date)
      else
        super(File.open(file_or_date, 'r'), file_or_date)
      end
    end

    def parse_time_from_filename
    end

    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = TZ.local_to_utc(Time.strptime(s, "%Y-%m-%d %H:%M:%S"))
    end
  end

  class ScadaReform < Base
    include SemanticLogger::Loggable
    include Out::Unit

    URL = 'http://data.wa.aemo.com.au/public/market-data/wemde/facilityScada/previous/'
    FILE_FORMAT = 'FacilityScada_%Y%m%d.zip'
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'

    def initialize(file_or_date)
      @from = parse_time_from_filename(file_or_date)
      @to = @from + 1.day
      @units = {}
      @default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first
      @area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      super
    end

    def self.select_file? url
      url =~ /.zip$/i
    end

    def parse_time_from_filename(file)
      time = Time.strptime(File.basename(file), FILE_FORMAT)
      TZ.local_to_utc(time)
    end

    def parse_unit(unit_internal_id)
      @units[unit_internal_id] ||= ::Unit.
                                     create_with(area_id: @area_id,
                                                 production_type_id: @default_production_type_id).
                                     find_or_create_by!(internal_id: unit_internal_id)
    end

    def process_file(body)
      json = FastJsonparser.parse(body, symbolize_keys: false)
      r = json['data']['facilityScadaDispatchIntervals'].map do |row|
        time = Time.strptime(row['dispatchInterval'], TIME_FORMAT)
        time = TZ.local_to_utc(time)
        unit = parse_unit(row['code'])
        # seems to be MWh per 5 minutes
        value = row['quantity']*1000*12

        {time:, unit_id: unit.id, value:}
      end

      r
    end

    def done!
      GenerationUnit.aggregate_to_generation(@from, @to, "a.id=#{@area_id}")
      super
    end
  end

  class Scada < Base
    include SemanticLogger::Loggable
    include Out::Unit

    URL = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/"
    # MANIFEST: https://data.wa.aemo.com.au/public/public-data/manifests/facility-scada.yaml
    FILE_FORMAT = "facility-scada-%Y-%m.csv"
    URL_FORMAT = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/#{FILE_FORMAT}"

    def self.cli_range(range)
      range.select { |d| d.day==1 }
    end

    def initialize(file_or_date)
      if file_or_date.is_a? Date
        @from = file_or_date.to_time
        @from = TZ.local_to_utc(@from)
      else
        @from = parse_time_from_filename(file_or_date)
      end
      @to = @from + 1.month if @from
      @units = {}
      @default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first
      @area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      super
    end

    def parse_time_from_filename(file)
      time = Time.strptime(File.basename(file), FILE_FORMAT)
      TZ.local_to_utc(time)
    end

    def parse_unit(unit_internal_id)
      @units[unit_internal_id] ||= ::Unit.
                                     create_with(area_id: @area_id,
                                                 production_type_id: @default_production_type_id).
                                     find_or_create_by!(internal_id: unit_internal_id)
    end

    def process_rows(all)
      all.shift
      dups = Set.new
      r = logger.benchmark_info("parse csv") do
        all.map do |row|
          # Trading Date
          # Interval Number
          # Trading Interval
          time = parse_time(row[2])
          # Participant Code
          # Facility Code
          unit = parse_unit(row[4])
          unit_id = unit.id
          # Energy Generated (MWh)
          # EOI Quantity (MW)
          value = row[6].to_f*1000
          # Extracted At
          #puts row.inspect if row[7].blank?
          next if row[2] == '2018-10-12 08:00:00' && row[3] == 'WPGENER' && row[4] == 'ALBANY_WF1'
          next if row[2] == '2018-10-12 08:00:00' && row[3] == 'WPGENER' && row[4] == 'GRASMERE_WF1'
          k = [time,unit_id]
          binding.pry if dups.include? k
          dups << k
          {time:, unit_id:, value:}
        end
      end
      r.compact!
      #require 'pry' ; binding.pry

      r
    end

    def done!
      GenerationUnit.aggregate_to_generation(@from, @to, "a.id=#{@area_id}")
      super
    end
  end

  class ScadaLive < Scada
    include SemanticLogger::Loggable
    URL = "https://wa.aemo.com.au/aemo/data/wa/infographic/facility-intervals-last96.csv"
    def self.cli(args)
      if args.length > 1
        $stderr.puts "#{$0} [file.csv]"
        exit 1
      end
      self.new(*args).process
    end

    def initialize(url_or_path = URL)
      super(url_or_path)
    end

    def parse_time_from_filename(file)
    end

    def process_rows(all)
      all.shift
      r = all.map do |row|
        #PERIOD
        time = parse_time(row[0])
        #PARTICIPANT_CODE
        #FACILITY_CODE
        unit = parse_unit(row[2])
        unit_id = unit.id
        #ACTUAL_MW
        value = row[3].to_f*1000
        #PCT_ALT_FUEL
        #PEAK_MW
        #OUTAGE_MW
        #PEAK_OUTAGE_MW
        #POTENTIAL_MWH
        #INTERVALS_GENERATING
        #TOTAL_INTERVALS
        #PCT_GENERATING
        #AS_AT
        {time:, unit_id:, value:}
      end
      @from = r.first[:time]
      @to = r.last[:time]
      #require 'pry' ; binding.pry

      r
    end
  end

  class ReferenceTradingPrice < Base
    include SemanticLogger::Loggable
    include Out::Price

    URL = 'http://data.wa.aemo.com.au/public/market-data/wemde/referenceTradingPrice/previous/'
    FILE_FORMAT = 'ReferenceTradingPrice_%Y%m%d.zip'
    URL_FORMAT = URL+FILE_FORMAT
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'

    def self.select_file? url
      url =~ /.zip$/i
    end

    def process_file(body)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      json = FastJsonparser.parse(body, symbolize_keys: false)
      r = json['data']['referenceTradingPrices'].map do |row|
        time = Time.strptime(row['tradingInterval'], TIME_FORMAT)
        time = TZ.local_to_utc(time)
        value = row['referenceTradingPrice']*100

        {time:, area_id:, value:}
      end
    end
  end

  #pre-reform price and load
  class Balancing < Base
    include SemanticLogger::Loggable

    URL = 'https://data.wa.aemo.com.au/datafiles/balancing-summary/'
    URL_FORMAT = 'https://data.wa.aemo.com.au/datafiles/balancing-summary/balancing-summary-%Y.csv'

    # FIXME: set @from and @to

    def process_rows(all)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first

      all.shift
      load_r = []
      price_r = []

      all.each do |row|
        #Trading Date
        #Interval Number
        #Trading Interval
        time = parse_time(row[2])
        #Load Forecast (MW)
        #Forecast As At
        #Scheduled Generation (MW)
        #Non-Scheduled Generation (MW)
        #Total Generation (MW)
        load = row[7].to_f*1000
        #Final Price ($/MWh)
        price = row[8].to_f*100
        #Extracted At

        load_r << {time:, area_id:, value: load}
        price_r << {time:, area_id:, value: price}
      end
      #require 'pry' ; binding.pry

      Out2::Load.run(load_r, @from, @to, self.class.source_id)
      Out2::Price.run(price_r, @from, @to, self.class.source_id)
    end
  end

  class BalancingLive < Balancing
    include SemanticLogger::Loggable
    URL = "https://data.wa.aemo.com.au/public/infographic/neartime/pulse.csv"
    def self.cli(args)
      if args.length > 1
        $stderr.puts "#{$0} [file.csv]"
        exit 1
      end
      self.new(*args).process
    end

    def initialize(url_or_path = URL)
      super(url_or_path)
    end

    #def parse_time s
    #  TZ.local_to_utc(Time.strptime(s, "%m/%d/%Y %H:%M:%S"))
    #end

    def process_rows(all)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      load_r = []
      price_r = []

      all.shift
      all.each do |row|
        # TRADING_DAY_INTERVAL
        time = parse_time(row[0])
        # FORECAST_EOI_MW
        #FORECAST_MW
        #PRICE
        price = row[3].to_f*100
        #FORECAST_NSG_MW
        #ACTUAL_NSG_MW
        #ACTUAL_TOTAL_GENERATION
        load = row[6].to_f*1000
        #RTD_TOTAL_GENERATION
        #RTD_TOTAL_SPINNING_RESERVE
        #LFAS_UP_REQUIREMENT_MW
        #TOTAL_OUTAGE_MW
        #PLANNED_OUTAGE_MW
        #FORCED_OUTAGE_MW
        #CONS_OUTAGE_MW
        #AS_AT

        load_r << {time:, area_id:, value: load}
        price_r << {time:, area_id:, value: price}
      end
      #require 'pry' ; binding.pry

      Out2::Load.run(load_r, @from, @to, self.class.source_id)
      Out2::Price.run(price_r, @from, @to, self.class.source_id)
    end
  end

  class DistributedPv < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL = 'https://data.wa.aemo.com.au/public/public-data/datafiles/distributed-pv/'
    FILE_FORMAT = 'distributed-pv-%Y.csv'
    URL_FORMAT = URL+FILE_FORMAT

    def initialize(file_or_date)
      if file_or_date.is_a? Date
        @from = file_or_date.to_time
      else
        @from = Time.strptime(File.basename(file_or_date), FILE_FORMAT)
      end
      @from = TZ.local_to_utc(@from)
      @to = @from + 1.year
      super
    end

    def process_rows(all)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      all.shift
      r = all.map do |row|
        #Trading Date
        #Interval Number
        #Trading Interval
        time = parse_time(row[2])
        #Estimated DPV Generation (MW)
        value = row[3].to_f*1000
        #Extracted At
        {time:, area_id:, production_type: 'solar_rooftop', value:}
      end
      #require 'pry' ; binding.pry

      r
    end

    def done!
      Generation.aggregate_rooftoppv_to_capture(@from, @to, "a.code='WEM'")
      super
    end
  end

  class DistributedPvLive < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL = 'https://wa.aemo.com.au/aemo/data/wa/infographic/dpvopdemand/distributed-pv_opdemand.csv'

    def self.cli(args)
      if args.length > 1
        $stderr.puts "#{$0} [file.csv]"
        exit 1
      end
      self.new(*args).process
    end

    def initialize(url_or_path = URL)
      super(url_or_path)
    end

    def process_rows(all)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      r = []
      all.shift
      all.each do |row|
        #Trading Interval
        time = parse_time(row[0])
        #Interval Number
        #Estimated DPV Generation (MW)
        value = row[2].to_f*1000
        #Operational Demand (MW)
        #Extracted At
        r << {time:, area_id:, production_type: 'solar_rooftop', value:}
      end
      @from = r.first[:time]
      @to = r.last[:time]
      #require 'pry' ; binding.pry

      r
    end

    def done!
      Generation.aggregate_rooftoppv_to_capture(@from, @to, "a.code='WEM'")
      super
    end
  end

  class BalancingHistoric < Base
    include SemanticLogger::Loggable
    include Out::Price

    URL = 'https://data.wa.aemo.com.au/datafiles/historical-balancing-prices/pre-balancing-market-data.csv'

    def process_rows(all)
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      all.shift
      r = all.map do |row|
        #Trade Date
        #Delivery Date
        #Delivery Hour
        time = Time.strptime("#{row[1]} #{row[2]}", '%Y-%m-%d %k')
        time = TZ.local_to_utc(time)
        #Delivery Interval
        time += 30.minutes if row[3] == '2'
        #MCAP Price Per MWh
        value = row[4]
        #UDAP Price Per MWh
        #DDAP Price Per MWh
        #Extracted At
        {area_id:, time:, value:}
      end
      #require 'pry' ; binding.pry

      r
    end
  end
end
