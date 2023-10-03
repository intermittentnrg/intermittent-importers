module AemoNem
  class Base < ::Aemo::Base
    TZ = TZInfo::Timezone.get('Etc/GMT-10')
    URL_BASE = "https://nemweb.com.au"
    INDEX_TIME_FORMAT = "%A, %B %d, %Y %l:%M %p"

    def self.cli(args)
      if args.present?
        args.each do |file|
          self.new(File.open(file), file).process
        end
      else
        self.each &:process
      end
    end
  end

  class Trading < Base
    include SemanticLogger::Loggable
    include Out::Price

    URL = "https://nemweb.com.au/Reports/Current/TradingIS_Reports/"

    def process_rows(all)
      all.select { |row| row[0..2] == ['D','TRADING','PRICE'] }.map do |row|
        # I
        # TRADING
        # PRICE
        # 3
        # SETTLEMENTDATE
        time = parse_time(row[4])
        # RUNNO
        # REGIONID
        country = row[6]
        # PERIODID
        # RRP
        value = row[8].to_f*100
        # EEP
        # INVALIDFLAG
        # LASTCHANGED
        # ROP
        # RAISE6SECRRP
        # RAISE6SECROP
        # RAISE60SECRRP
        # RAISE60SECROP
        # RAISE5MINRRP
        # RAISE5MINROP
        # RAISEREGRRP
        # RAISEREGROP
        # LOWER6SECRRP
        # LOWER6SECROP
        # LOWER60SECRRP
        # LOWER60SECROP
        # LOWER5MINRRP
        # LOWER5MINROP
        # LOWERREGRRP
        # LOWERREGROP
        # RAISE1SECRRP
        # RAISE1SECROP
        # LOWER1SECRRP
        # LOWER1SECROP
        # PRICE_STATUS

        {time:, country:, value:}
      end
    end
  end

  class Dispatch < Base
    include SemanticLogger::Loggable
    include Out::Load

    URL = 'https://nemweb.com.au/Reports/Current/DispatchIS_Reports/'

    def process_rows(all)
      r = {}
      all.select { |row| row[0..2] == ['D','DISPATCH','REGIONSUM'] }.map do |row|
        #I
        #DISPATCH
        #REGIONSUM
        #7
        #SETTLEMENTDATE
        time = parse_time(row[4])
        #RUNNO
        #REGIONID
        country = row[6]
        #DISPATCHINTERVAL
        #INTERVENTION
        #TOTALDEMAND
        ###value = row[9]
        #AVAILABLEGENERATION
        #AVAILABLELOAD
        #DEMANDFORECAST
        #DISPATCHABLEGENERATION
        #DISPATCHABLELOAD
        #NETINTERCHANGE
        #EXCESSGENERATION
        #LOWER5MINDISPATCH
        #LOWER5MINIMPORT
        #LOWER5MINLOCALDISPATCH
        #LOWER5MINLOCALPRICE
        #LOWER5MINLOCALREQ
        #LOWER5MINPRICE
        #LOWER5MINREQ
        #LOWER5MINSUPPLYPRICE
        #LOWER60SECDISPATCH
        #LOWER60SECIMPORT
        #LOWER60SECLOCALDISPATCH
        #LOWER60SECLOCALPRICE
        #LOWER60SECLOCALREQ
        #LOWER60SECPRICE
        #LOWER60SECREQ
        #LOWER60SECSUPPLYPRICE
        #LOWER6SECDISPATCH
        #LOWER6SECIMPORT
        #LOWER6SECLOCALDISPATCH
        #LOWER6SECLOCALPRICE
        #LOWER6SECLOCALREQ
        #LOWER6SECPRICE
        #LOWER6SECREQ
        #LOWER6SECSUPPLYPRICE
        #RAISE5MINDISPATCH
        #RAISE5MINIMPORT
        #RAISE5MINLOCALDISPATCH
        #RAISE5MINLOCALPRICE
        #RAISE5MINLOCALREQ
        #RAISE5MINPRICE
        #RAISE5MINREQ
        #RAISE5MINSUPPLYPRICE
        #RAISE60SECDISPATCH
        #RAISE60SECIMPORT
        #RAISE60SECLOCALDISPATCH
        #RAISE60SECLOCALPRICE
        #RAISE60SECLOCALREQ
        #RAISE60SECPRICE
        #RAISE60SECREQ
        #RAISE60SECSUPPLYPRICE
        #RAISE6SECDISPATCH
        #RAISE6SECIMPORT
        #RAISE6SECLOCALDISPATCH
        #RAISE6SECLOCALPRICE
        #RAISE6SECLOCALREQ
        #RAISE6SECPRICE
        #RAISE6SECREQ
        #RAISE6SECSUPPLYPRICE
        #AGGEGATEDISPATCHERROR
        #AGGREGATEDISPATCHERROR
        #LASTCHANGED
        #INITIALSUPPLY
        #CLEAREDSUPPLY
        #LOWERREGIMPORT
        #LOWERREGLOCALDISPATCH
        #LOWERREGLOCALREQ
        #LOWERREGREQ
        #RAISEREGIMPORT
        #RAISEREGLOCALDISPATCH
        #RAISEREGLOCALREQ
        #RAISEREGREQ
        #RAISE5MINLOCALVIOLATION
        #RAISEREGLOCALVIOLATION
        #RAISE60SECLOCALVIOLATION
        #RAISE6SECLOCALVIOLATION
        #LOWER5MINLOCALVIOLATION
        #LOWERREGLOCALVIOLATION
        #LOWER60SECLOCALVIOLATION
        #LOWER6SECLOCALVIOLATION
        #RAISE5MINVIOLATION
        #RAISEREGVIOLATION
        #RAISE60SECVIOLATION
        #RAISE6SECVIOLATION
        #LOWER5MINVIOLATION
        #LOWERREGVIOLATION
        #LOWER60SECVIOLATION
        #LOWER6SECVIOLATION
        #RAISE6SECACTUALAVAILABILITY
        #RAISE60SECACTUALAVAILABILITY
        #RAISE5MINACTUALAVAILABILITY
        #RAISEREGACTUALAVAILABILITY
        #LOWER6SECACTUALAVAILABILITY
        #LOWER60SECACTUALAVAILABILITY
        #LOWER5MINACTUALAVAILABILITY
        #LOWERREGACTUALAVAILABILITY
        #LORSURPLUS
        #LRCSURPLUS
        #TOTALINTERMITTENTGENERATION
        #DEMAND_AND_NONSCHEDGEN
        value = row[105].to_f*1000
        #UIGF
        #SEMISCHEDULE_CLEAREDMW
        #SEMISCHEDULE_COMPLIANCEMW
        #SS_SOLAR_UIGF
        #SS_WIND_UIGF
        #SS_SOLAR_CLEAREDMW
        #SS_WIND_CLEAREDMW
        #SS_SOLAR_COMPLIANCEMW
        #SS_WIND_COMPLIANCEMW
        #WDR_INITIALMW
        #WDR_AVAILABLE
        #WDR_DISPATCHED
        #RAISE1SECLOCALDISPATCH
        #LOWER1SECLOCALDISPATCH
        #RAISE1SECACTUALAVAILABILITY
        #LOWER1SECACTUALAVAILABILITY
        #SS_SOLAR_AVAILABILITY
        #SS_WIND_AVAILABILITY
        k = [country, time]
        r[k] = {country:, time:, value:}
      end
      #require 'pry' ; binding.pry

      r.values
    end
  end

  class Scada < Base
    include SemanticLogger::Loggable
    include Out::Unit

    URL = 'https://nemweb.com.au/Reports/Current/Dispatch_SCADA/'
    FILE_MATCHER = /PUBLIC_DISPATCHSCADA_(\d{12})_/
    FILE_FORMAT = '%Y%m%d%H%M'

    def initialize(url_or_io, name_if_io = nil)
      unless @from
        name = File.basename(name_if_io || url_or_io)
        m = name.match(FILE_MATCHER)
        raise ArgumentError, 'invalid filename' unless m
        @from = Time.strptime(m[1], FILE_FORMAT)
        @from = TZ.local_to_utc(@from)
        @to = @from + 5.minutes
      end
      super
    end

    def self.clear_cache!
      @@units = {}
    end
    @@units = {}
    def process_rows(all)
      # require 'pry' ; binding.pry
      default_area_id = Area.where(type: 'country', source: self.class.source_id).pluck(:id).first
      default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first

      r = logger.benchmark_info("parse csv") do
        all.select { |row| row[0..2] == ['D','DISPATCH','UNIT_SCADA'] }.map do |row|
          # I
          # DISPATCH
          # UNIT_SCADA
          # 1
          # SETTLEMENTDATE
          time = parse_time(row[4])
          # DUID
          unit_internal_id = row[5]
          unit = @@units[unit_internal_id] ||= ::Unit.
                                               create_with(area_id: default_area_id,
                                                           production_type_id: default_production_type_id).
                                               find_or_create_by!(internal_id: unit_internal_id)
          unit_id = unit.id
          # SCADAVALUE
          value = row[6].to_f*1000
          if ["hydro_pumped_storage","battery_charging"].include? unit.production_type.name
            value = -value
          end

          {time:, unit_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r
    end

    def done!
      if @@units.present?
        where = "a.source='aemo' AND a.code<>'WEM'"
        GenerationUnit.aggregate_to_generation(@from, @to, where)
      end
      super
    end
  end

  class RooftopPv < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL = "https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/"

    def initialize *args
      super
      unless @from
        # PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168830.zip
        filename = File.basename(@url)
        m = /_(\d{14})_\d{16}\.zip$/.match(filename)
        @from = Time.strptime(m[1], '%Y%m%d%H%M%S')
        @from = TZ.local_to_utc(@from)
        @to = @from + 5.minutes
      end
    end

    def self.select_file? url
      super && url =~ /PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_/
    end

    def process_rows(all)
      r = all.select { |row| row[0..2] == ['D','ROOFTOP','ACTUAL'] && row[8] == 'MEASUREMENT' }.map do |row|
        # I
        # ROOFTOP
        # ACTUAL
        # 2
        # INTERVAL_DATETIME
        time = parse_time(row[4])
        # REGIONID
        country = row[5]
        # POWER
        value = row[6].to_f*1000
        # QI
        # TYPE
        # LASTCHANGED
        next unless country =~ /1$/

        {time:, country:, production_type: 'solar_rooftop', value:}
      end
      r.compact!

      r
    end

    def done!
      Generation.aggregate_rooftoppv_to_capture(@from, @to, "a.code <> 'WEM'")
      super
    end
  end
end
