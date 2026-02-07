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
          self.new.add_date(date).done!
        end
      elsif args.present?
        target = self.new
        args.each do |path|
          target.add_file(path)
        end
        target.done!
      else
        target = self.new
        self.each do |arg|
          target.add(arg)
        end
        target.done!
      end
    end

    def self.cli_range(range)
      range.select { |d| d.month==1 && d.day==1 }
    end

    def self.select_file? url
      url =~ /.csv$/i
    end

    def add_date date
      add_url(date.strftime(self.class::URL_FORMAT))
    end

    def parse_filename! name
      @from = Time.strptime(File.basename(name), self.class::FILE_FORMAT)
      @from = TZ.local_to_utc(@from)
      @to = @from + 1.year
    end

    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = TZ.local_to_utc(Time.strptime(s, "%Y-%m-%d %H:%M:%S"))
    end
  end

  class ScadaReform < Base
    include SemanticLogger::Loggable

    URL = 'http://data.wa.aemo.com.au/public/market-data/wemde/facilityScada/previous/'
    FILE_FORMAT = 'FacilityScada_%Y%m%d.zip'
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'

    def initialize
      super
      @r = []
      @units = {}
      @default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first
      @area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
    end

    def self.select_file? url
      url =~ /.zip$/i
    end

    def parse_filename! name
      super
      @to = @from + 1.day
    end

    def parse_unit(unit_internal_id)
      @units[unit_internal_id] ||= ::Unit.
                                     create_with(area_id: @area_id,
                                                 production_type_id: @default_production_type_id).
                                     find_or_create_by!(internal_id: unit_internal_id)
    end

    def add_buffer2 data
      add_json(FastJsonparser.parse(data, symbolize_keys: false))
    end

    def add_json json
      json['data']['facilityScadaDispatchIntervals'].each do |row|
        time = Time.strptime(row['dispatchInterval'], TIME_FORMAT)
        time = TZ.local_to_utc(time)
        unit = parse_unit(row['code'])
        # seems to be MWh per 5 minutes
        value = row['quantity']*1000*12

        @r << {time:, unit_id: unit.id, value:}
      end
    end

    def done!
      Out::Unit.run(@r, @from, @to, self.class.source_id)
      GenerationUnit.aggregate_to_generation(@from, @to, "a.source='aemo' AND a.id=#{@area_id}")
      super
    end
  end

  class Scada < Base
    include SemanticLogger::Loggable

    URL = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/"
    # MANIFEST: https://data.wa.aemo.com.au/public/public-data/manifests/facility-scada.yaml
    FILE_FORMAT = "facility-scada-%Y-%m.csv"
    URL_FORMAT = "https://data.wa.aemo.com.au/public/public-data/datafiles/facility-scada/#{FILE_FORMAT}"

    def self.cli_range(range)
      range.select { |d| d.day==1 }
    end

    def initialize
      super
      @r = []
      @default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first
      @area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      @units = {}
    end

    def parse_filename! name
      super
      @to = @from + 1.month
    end

    def parse_unit(unit_internal_id)
      @units[unit_internal_id] ||= ::Unit.
                                     create_with(area_id: @area_id,
                                                 production_type_id: @default_production_type_id).
                                     find_or_create_by!(internal_id: unit_internal_id)
    end

    def add_csv csv
      dups = Set.new
      logger.benchmark_info("parse csv") do
        csv[1..].each do |row|
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
          @r << {time:, unit_id:, value:}
        end
      end
    end

    def done!
      return if @r.empty?
      Out::Unit.run(@r, @from, @to, self.class.source_id)
      GenerationUnit.aggregate_to_generation(@from, @to, "a.source='aemo' AND a.id=#{@area_id}")
      super
    end
  end

  class OperationalDemand < Base
    include SemanticLogger::Loggable

    URL = 'http://data.wa.aemo.com.au/public/market-data/wemde/operationalDemandWithdrawal/dailyFiles/'
    FILE_FORMAT = 'OperationalDemandAndWithdrawal_%Y-%m-%d.json'
    URL_FORMAT = URL+FILE_FORMAT
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'

    def self.select_file? url
      url =~ /.json$/i
    end

    def add_buffer2 data
      add_json(FastJsonparser.parse(data, symbolize_keys: false))
    end

    def add_json(json)
      #require 'pry';binding.pry
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      r = json['data']['data'].map do |row|
        time = Time.strptime(row['dispatchInterval'], TIME_FORMAT)
        time = TZ.local_to_utc(time)
        value = row['operationalDemand']*1000

        {time:, area_id:, value:}
      end

      Out::Load.run(r, @from, @to, self.class.source_id)
      done!
    end
  end

  class ReferenceTradingPrice < Base
    include SemanticLogger::Loggable

    URL = 'http://data.wa.aemo.com.au/public/market-data/wemde/referenceTradingPrice/previous/'
    FILE_FORMAT = 'ReferenceTradingPrice_%Y%m%d'
    URL_FORMAT = URL+FILE_FORMAT+".zip"
    TIME_FORMAT = '%Y-%m-%dT%H:%M:%S%:z'

    def self.select_file? url
      url =~ /.zip$/i
    end

    def add_buffer2 data
      add_json(FastJsonparser.parse(data, symbolize_keys: false))
    end

    def add_json json
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      if json.is_a?(Array) && json.length == 1
        json = json.first
      end
      r = json['data']['referenceTradingPrices'].map do |row|
        time = Time.strptime(row['tradingInterval'], TIME_FORMAT)
        time = TZ.local_to_utc(time)
        value = row['referenceTradingPrice']*100

        {time:, area_id:, value:}
      end

      Out::Price.run(r, @from, @to, self.class.source_id)
      done!
    end
  end

  #pre-reform price and load
  class Balancing < Base
    include SemanticLogger::Loggable

    URL = 'https://data.wa.aemo.com.au/datafiles/balancing-summary/'
    FILE_FORMAT = 'balancing-summary-%Y.csv'
    URL_FORMAT = URL+FILE_FORMAT

    # FIXME: set @from and @to

    def initialize
      super
      @load_r = []
      @price_r = []
    end

    def add_csv csv
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      csv[1..].each do |row|
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

        @load_r << {time:, area_id:, value: load}
        @price_r << {time:, area_id:, value: price}
      end
      #require 'pry' ; binding.pry
    end

    def done!
      Out::Load.run(@load_r, @from, @to, self.class.source_id)
      Out::Price.run(@price_r, @from, @to, self.class.source_id)
      super
    end
  end

  class BalancingLive < Balancing
    include SemanticLogger::Loggable

    URL = "https://data.wa.aemo.com.au/public/infographic/neartime/pulse.csv"

    def self.cli(args)
      if args.empty?
        refresh
      else
        target = self.new
        args.each do |path|
          target.add_file(path)
        end
        target.done!
      end
    end

    def self.refresh
      self.new.add_url(URL).done!
    end
    def parse_filename! name
    end
    #def parse_time s
    #  TZ.local_to_utc(Time.strptime(s, "%m/%d/%Y %H:%M:%S"))
    #end

    def add_csv csv
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      csv[1..].each do |row|
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

        @load_r << {time:, area_id:, value: load}
        @price_r << {time:, area_id:, value: price}
      end
    end
  end

  class DistributedPv < Base
    include SemanticLogger::Loggable

    URL = 'https://data.wa.aemo.com.au/public/public-data/datafiles/distributed-pv/'
    FILE_FORMAT = 'distributed-pv-%Y.csv'
    URL_FORMAT = URL+FILE_FORMAT

    def initialize
      super
      @r = []
    end

    def add_csv csv
      csv[1..].each do |row|
        #Trading Date
        #Interval Number
        #Trading Interval
        time = parse_time(row[2])
        #Estimated DPV Generation (MW)
        value = row[3].to_f*1000
        #Extracted At
        @r << {time:, country: 'WEM', production_type: 'solar_rooftop', value:}
      end
    end

    def done!
      Out::Generation.run(@r, @from, @to, self.class.source_id)
      Generation.aggregate_rooftoppv_to_capture(@from, @to, "a.code='WEM'")
      super
    end
  end

  class DistributedPvLive < Base
    include SemanticLogger::Loggable

    URL = 'https://wa.aemo.com.au/aemo/data/wa/infographic/dpvopdemand/distributed-pv_opdemand.csv'

    def self.cli(args)
      if args.empty?
        self.new.add_url(URL).done!
      else
        target = self.new
        args.each do |path|
          target.add_file(path)
        end
        target.done!
      end
    end

    def initialize
      super
      @r = []
    end

    def parse_filename! name
    end

    def add_csv csv
      csv[1..].each do |row|
        #Trading Interval
        time = parse_time(row[0])
        #Interval Number
        #Estimated DPV Generation (MW)
        value = row[2].to_f*1000
        #Operational Demand (MW)
        #Extracted At
        @r << {time:, country: 'WEM', production_type: 'solar_rooftop', value:}
      end
      @from = @r.first[:time]
      @to = @r.last[:time]
    end

    def done!
      Out::Generation.run(@r, @from, @to, self.class.source_id)
      Generation.aggregate_rooftoppv_to_capture(@from, @to, "a.code='WEM'")
      super
    end
  end

  class BalancingHistoric < Base
    include SemanticLogger::Loggable

    URL = 'https://data.wa.aemo.com.au/datafiles/historical-balancing-prices/pre-balancing-market-data.csv'

    def initialize
      super
      @r = []
    end

    def parse_filename! name
    end

    def add_csv csv
      area_id = Area.where(code: 'WEM', type: 'region', source: self.class.source_id).pluck(:id).first
      csv[1..].each do |row|
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
        @r << {area_id:, time:, value:}
      end
    end

    def done!
      Out::Price.run(@r, @from, @to, self.class.source_id)
      super
    end
  end
end
