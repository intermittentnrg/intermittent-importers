require 'fastest_csv'

module AemoNem
  class Base < ::Aemo::Base
    include CliMixin::Loop

    TZ = TZInfo::Timezone.get('Etc/GMT-10')
    URL_BASE = "https://nemweb.com.au"
    INDEX_TIME_FORMAT = "%A, %B %d, %Y %l:%M %p"
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

      #from_area_id = Area.find_by source: self.class.source_id, code: 'TAS1'
      #to_area_id = Area.find_by source: self.class.source_id, code: 'VIC1'
      r_tran = {}
      all.select { |row| row[0..2] == ['D', 'DISPATCH', 'INTERCONNECTORRES'] && row[6] == 'T-V-MNSP1'}.each do |row|
        #0:I
        #1:DISPATCH
        #2:INTERCONNECTORRES
        #3:3
        #4:SETTLEMENTDATE
        time = parse_time(row[4])
        #5:RUNNO
        #6:INTERCONNECTORID
        #7:DISPATCHINTERVAL
        #8:INTERVENTION
        #9:METEREDMWFLOW
        value = row[9].to_f*1000
        #MWFLOW,MWLOSSES
        #MARGINALVALUE
        #VIOLATIONDEGREE
        #LASTCHANGED
        #EXPORTLIMIT
        #IMPORTLIMIT
        #MARGINALLOSS
        #EXPORTGENCONID
        #IMPORTGENCONID
        #FCASEXPORTLIMIT
        #FCASIMPORTLIMIT
        #LOCAL_PRICE_ADJUSTMENT_EXPORT
        #LOCALLY_CONSTRAINED_EXPORT
        #LOCAL_PRICE_ADJUSTMENT_IMPORT
        #LOCALLY_CONSTRAINED_IMPORT

        from_area = 'VIC1'
        to_area = 'TAS1'

        k = [time, from_area, to_area]
        r_tran[k] = {time:, from_area:, to_area:, value:}
      end

      all.select { |row| row[0..2] == ['D', 'DISPATCH', 'INTERCONNECTION'] }.map do |row|
        #I
        #DISPATCH
        #INTERCONNECTION
        #1
        #SETTLEMENTDATE
        time = parse_time(row[4])
        #RUNNO
        #INTERVENTION
        #7:FROM_REGIONID
        to_area = row[7]
        #8:TO_REGIONID
        from_area = row[8]
        #DISPATCHINTERVAL
        #IRLF
        #MWFLOW
        #12:METEREDMWFLOW
        value = row[12].to_f*1000
        #FROM_REGION_MW_LOSSES
        #TO_REGION_MW_LOSSES
        #LASTCHANGED

        k = [time, from_area, to_area]
        r_tran[k] = {time:, from_area:, to_area:, value:}
      end
      #require 'pry' ; binding.pry
      Out2::Transmission.run(r_tran.values, @from, @to, self.class.source_id)

      r = {}
      all.select { |row| row[0..2] == ['D','DISPATCH','REGIONSUM'] }.each do |row|
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

  class CauserPays < Base
    include SemanticLogger::Loggable
    include Out::UnitHires

    URL = 'http://www.nemweb.com.au/Reports/Current/Causer_Pays/'
    FILE_MATCHER = /FCAS_(\d{12}).zip/
    FILE_FORMAT = '%Y%m%d%H%M'
    #ELEMENTS_URL = 'http://www.nemweb.com.au/Reports/Current/Causer_Pays_Elements/'


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

    @@elements = false
    def self.elements
      return @@elements if @@elements
      url = 'http://www.nemweb.com.au/Reports/Current/Causer_Pays_Elements/Elements_FCAS_202402020950.csv'
      logger.info("Fetch #{url}")
      res = @@faraday.get(url)

      csv = FastestCSV.parse(res.body, row_sep: "\r\n")
      @@elements = {}
      csv.each do |row|
        id = row[0].to_i
        element = row[1].strip
        next unless element =~ /^SUBSTN\./
        element.gsub! /^SUBSTN\./, ''
        @@elements[id] = element
      end

      @@elements
    end

    ROW_TIME_FORMAT = '%Y-%m-%d %H:%M:%S'

    @@units = {}
    def process_rows(all)
      default_area_id = Area.where(type: 'country', source: self.class.source_id).pluck(:id).first
      default_production_type_id = ProductionType.where(name: 'other').pluck(:id).first

      r = []
      logger.benchmark_info("parse csv") do
        all.each do |row|
          time = parse_time(row[0])
          unit_internal_id = self.class.elements[row[1].to_i]
          next unless unit_internal_id
          unit = @@units[unit_internal_id]
          unit ||= ::Unit.find_by(hires_internal_id: unit_internal_id)
          unit ||= ::Unit.
                     create_with(area_id: default_area_id,
                                 production_type_id: default_production_type_id).
                     find_or_create_by!(internal_id: unit_internal_id)
          @@units[unit_internal_id] ||= unit

          unit_id = unit.id
          variable = row[2].to_i
          next unless variable == 2
          value = row[3].to_f*1000

          r << {time:, unit_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r
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
      GenerationUnit.aggregate_to_generation(@from, @to, "a.code<>'WEM'")
      super
    end
  end

  class GenUnits < Base
    include SemanticLogger::Loggable

    @@units = {}
    def process_rows(all)
      raise 'not used'
      logger.benchmark_info("parse csv") do
        all.select { |row| row[0..2] == ['D','PARTICIPANT_REGISTRATION','GENUNITS'] }.map do |row|
          #I
          #PARTICIPANT_REGISTRATION
          #GENUNITS
          #2
          #GENSETID
          unit_internal_id = row[4]
          unit_id = @@units[unit_internal_id] ||= Unit.where(internal_id: unit_internal_id).pluck(:id).first
          unless unit_id
            logger.warn("No unit #{unit_internal_id}")
            next
          end
          #STATIONID
          #SETLOSSFACTOR
          #CDINDICATOR
          #AGCFLAG
          #SPINNINGFLAG
          #VOLTLEVEL
          #REGISTEREDCAPACITY
          #value = row[11].to_f*1000
          #DISPATCHTYPE
          #STARTTYPE
          #MKTGENERATORIND
          #NORMALSTATUS
          #MAXCAPACITY
          #GENSETTYPE
          #GENSETNAME
          #LASTCHANGED
          time = parse_time(row[19])
          #CO2E_EMISSIONS_FACTOR
          #CO2E_ENERGY_SOURCE
          #CO2E_DATA_SOURCE

          {unit_id:, time:, value:}
        end.compact
      end
    end
    def process
      #require 'pry' ; binding.pry
      Out2::UnitCapacity.run(@r, @from, @to, self.class.source_id)
      super
    end
  end

  class DuDetail < Base
    include SemanticLogger::Loggable

    #def initialize *args
    #end
    @@units = {}
    def process_rows(all)
      r = {}
      logger.benchmark_info("parse csv") do
        headers = Hash[all[1].each_with_index.to_a]
        all.select { |row| row[0..2] == ['D','PARTICIPANT_REGISTRATION','DUDETAIL'] }.each do |row|
          #I
          #PARTICIPANT_REGISTRATION
          #DUDETAIL
          #4
          #DUID
          unit_internal_id = row[headers["DUID"]]
          unit_id = @@units[unit_internal_id] ||= Unit.where(internal_id: unit_internal_id).pluck(:id).first
          unless unit_id
            logger.warn("No unit #{unit_internal_id}")
            next
          end
          #EFFECTIVEDATE
          time = parse_time(row[headers["EFFECTIVEDATE"]])
          #VERSIONNO
          #CONNECTIONPOINTID
          #VOLTLEVEL
          #REGISTEREDCAPACITY
          value = row[9].to_f*1000
          #AGCCAPABILITY
          #DISPATCHTYPE
          #MAXCAPACITY
          #value2 = row[12]
          #STARTTYPE
          #NORMALLYONFLAG
          #PHYSICALDETAILSFLAG
          #SPINNINGRESERVEFLAG
          #AUTHORISEDBY
          #AUTHORISEDDATE
          #LASTCHANGED
          #INTERMITTENTFLAG
          #SEMISCHEDULE_FLAG
          #MAXRATEOFCHANGEUP
          #MAXRATEOFCHANGEDOWN
          #DISPATCHSUBTYPE
          #ADG_ID
          k = [unit_id,time]
          r[k] = {unit_id:, time:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r.values
    end

    def process
      #require 'pry' ; binding.pry
      Out2::UnitCapacity.run(@r, @from, @to, self.class.source_id)
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
