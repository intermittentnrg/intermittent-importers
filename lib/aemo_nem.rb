module AemoNem
  class Base < ::Aemo::Base
    URL_BASE = "https://nemweb.com.au"
    INDEX_TIME_FORMAT = "%A, %B %d, %Y %l:%M %p"
  end
  class Dispatch < Base
    include SemanticLogger::Loggable
    include Out::Price

    URL = "https://nemweb.com.au/Reports/Current/DispatchIS_Reports/"

    def process_rows(all)
      #I,DISPATCH,CASE_SOLUTION,2,SETTLEMENTDATE,RUNNO,INTERVENTION,CASESUBTYPE,SOLUTIONSTATUS,SPDVERSION,NONPHYSICALLOSSES,TOTALOBJECTIVE,TOTALAREAGENVIOLATION,TOTALINTERCONNECTORVIOLATION,TOTALGENERICVIOLATION,TOTALRAMPRATEVIOLATION,TOTALUNITMWCAPACITYVIOLATION,TOTAL5MINVIOLATION,TOTALREGVIOLATION,TOTAL6SECVIOLATION,TOTAL60SECVIOLATION,TOTALASPROFILEVIOLATION,TOTALFASTSTARTVIOLATION,TOTALENERGYOFFERVIOLATION,LASTCHANGED,SWITCHRUNINITIALSTATUS,SWITCHRUNBESTSTATUS,SWITCHRUNBESTSTATUS_INT
      all.select { |row| row[0..2] == ['D','DISPATCH','PRICE'] }.map do |row|

        # I
        # DISPATCH
        # CASE_SOLUTION
        # 2
        # SETTLEMENTDATE
        time = parse_time(row[4])
        # RUNNO
        # REGIONID
        country = "DISPATCH-"+row[6]
        # DISPATCHINTERVAL
        # INTERVENTION
        # RRP
        value = row[9]
        # EEP
        # ROP
        # APCFLAG
        # MARKETSUSPENDEDFLAG
        # LASTCHANGED
        # RAISE6SECRRP
        # RAISE6SECROP
        # RAISE6SECAPCFLAG
        # RAISE60SECRRP
        # RAISE60SECROP
        # RAISE60SECAPCFLAG
        # RAISE5MINRRP
        # RAISE5MINROP
        # RAISE5MINAPCFLAG
        # RAISEREGRRP
        # RAISEREGROP
        # RAISEREGAPCFLAG
        # LOWER6SECRRP
        # LOWER6SECROP
        # LOWER6SECAPCFLAG
        # LOWER60SECRRP
        # LOWER60SECROP
        # LOWER60SECAPCFLAG
        # LOWER5MINRRP
        # LOWER5MINROP
        # LOWER5MINAPCFLAG
        # LOWERREGRRP
        # LOWERREGROP
        # LOWERREGAPCFLAG
        # PRICE_STATUS
        # PRE_AP_ENERGY_PRICE
        # PRE_AP_RAISE6_PRICE
        # PRE_AP_RAISE60_PRICE
        # PRE_AP_RAISE5MIN_PRICE
        # PRE_AP_RAISEREG_PRICE
        # PRE_AP_LOWER6_PRICE
        # PRE_AP_LOWER60_PRICE
        # PRE_AP_LOWER5MIN_PRICE
        # PRE_AP_LOWERREG_PRICE
        # CUMUL_PRE_AP_ENERGY_PRICE
        # CUMUL_PRE_AP_RAISE6_PRICE
        # CUMUL_PRE_AP_RAISE60_PRICE
        # CUMUL_PRE_AP_RAISE5MIN_PRICE
        # CUMUL_PRE_AP_RAISEREG_PRICE
        # CUMUL_PRE_AP_LOWER6_PRICE
        # CUMUL_PRE_AP_LOWER60_PRICE
        # CUMUL_PRE_AP_LOWER5MIN_PRICE
        # CUMUL_PRE_AP_LOWERREG_PRICE
        # OCD_STATUS
        # MII_STATUS
        # RAISE1SECRRP
        # RAISE1SECROP
        # RAISE1SECAPCFLAG
        # LOWER1SECRRP
        # LOWER1SECROP
        # LOWER1SECAPCFLAG
        # PRE_AP_RAISE1_PRICE
        # PRE_AP_LOWER1_PRICE
        # CUMUL_PRE_AP_RAISE1_PRICE
        # CUMUL_PRE_AP_LOWER1_PRICE

        {time:, country:, value:}
      end
    end
  end

  class Trading < Base
    include SemanticLogger::Loggable
    include Out::Price

    URL = "https://nemweb.com.au/Reports/Current/TradingIS_Reports/"

    def self.cli(args)
      AemoNem::Trading.each &:process_price
    end
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
        value = row[8].to_f
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

  class TradingMMS < Trading
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end

      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).select {|d| d.day==1}.each do |date|
        AemoNem::TradingMMS.new(date).process_price
      end
    end

    def initialize(date)
      url = date.strftime("https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_TRADINGPRICE_%Y%m010000.zip")
      @from = date
      @to = date + 1.month
      super(url)
    end
  end

  class Scada < Base
    include SemanticLogger::Loggable
    include Out::Unit

    URL = 'https://nemweb.com.au/Reports/Current/Dispatch_SCADA/'

    def self.cli(args)
      if args.present?
        args.each do |file|
          AemoNem::Scada.new(File.open(file), file).process
        end
      else
        AemoNem::Scada.each &:process
      end
    end

    def process_rows(all)
      @units ||= {}
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
          unit = @units[unit_internal_id] ||= ::Unit.
                                               create_with(area_id: default_area_id,
                                                           production_type_id: default_production_type_id).
                                               find_or_create_by!(internal_id: unit_internal_id)
          unit_id = unit.id
          # SCADAVALUE
          value = row[6].to_f*1000

          {time:, unit_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r
    end

    def done!
      where = "a.source='aemo'"
      GenerationUnit.aggregate_to_generation(where)
      super
    end
  end

  class ScadaMMS < Scada
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end

      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).select {|d| d.day==1}.each do |date|
        AemoNem::ScadaMMS.new(date).process
      end
    end

    def initialize(date)
      url = date.strftime("https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_DISPATCH_UNIT_SCADA_%Y%m010000.zip")
      @from = date
      @to = date + 1.month
      super(url)
    end
  end

  class RooftopPv < Base
    include SemanticLogger::Loggable
    include Out::Generation

    URL = "https://nemweb.com.au/Reports/Current/ROOFTOP_PV/ACTUAL/"

    def self.cli(args)
      AemoNem::RooftopPv.each &:process
    end
    def initialize *args
      super
      unless @from
        # PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_20230902183000_0000000396168830.zip
        filename = File.basename(@url)
        m = /_(\d{14})_\d{16}\.zip$/.match(filename)
        @from = Time.strptime(m[1], '%Y%m%d%H%M%S')
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

    def points_generation
      @r
    end
  end

  class RooftopPvMMS < RooftopPv
    include SemanticLogger::Loggable

    def self.cli(args)
      if args.length != 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end

      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      (from...to).select {|d| d.day==1}.each do |date|
        AemoNem::RooftopPvMMS.new(date).process
      end
    end

    def initialize(date)
      url = date.strftime("https://nemweb.com.au/Data_Archive/Wholesale_Electricity/MMSDM/%Y/MMSDM_%Y_%m/MMSDM_Historical_Data_SQLLoader/DATA/PUBLIC_DVD_ROOFTOP_PV_ACTUAL_%Y%m010000.zip")
      @from = date
      @to = date + 1.month
      super(url)
    end
  end
end