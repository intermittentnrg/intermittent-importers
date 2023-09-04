require 'faraday-http-cache'
require 'faraday/net_http_persistent'

module Aemo
  class Base
    TZ = TZInfo::Timezone.get('Etc/GMT-10')
    #TZ = TZInfo::Timezone.get('Australia/Brisbane')
    URL_BASE = "https://nemweb.com.au"

    @@store = ActiveSupport::Cache::FileStore.new "tmp/"
    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      f.use :http_cache, store: @store, serializer: Marshal
      #f.response :logger, logger
    end

    def self.source_id
      'aemo'
    end

    def self.select_file? url
      url =~ /.zip$/i
    end

    def self.each
      logger.info("Fetch #{self::URL}")
      http = @@faraday.get(self::URL)
      links = http.body.scan /HREF="(.*?)"/
      links.select! { |url| select_file?(url.first) }

      links.each do |url|
        url = URL_BASE + url.first
        next unless select_file?(url)
        if FileList.where(path: File.basename(url), source: self.source_id).exists?
          logger.info "already processed #{File.basename(url)}"
          next
        end
        yield self.new(url)
      end

      nil
    end

    def initialize(url_or_io, name_if_io = nil)
      if url_or_io.is_a?(String) # url
        @url = url_or_io
        http = logger.benchmark_info("Fetch #{@url}") do
          http = @@faraday.get(@url)
        end
        file = StringIO.new(http.body)
      else # io
        file = url_or_io
        @url = name_if_io
      end

      zip = Zip::InputStream.new(file)
      zip.get_next_entry
      body = zip.read
      csv = CSV.new(body)

      all = csv.to_a

      #r = all.select { |r| r[0..2] == ['D','TRADING','PRICE'] }.map do |r|
      @r = process_rows(all)
    end

    def done!
      FileList.create(path: File.basename(@url), source: self.class.source_id)
      logger.info "done! #{@url}"
    end

    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = TZ.local_to_utc(Time.strptime(s, '%Y/%m/%d %H:%M:%S'))
    end

    def points_price
      @r
    end
    def points
      @r
    end
  end

  class Archive < Base
    def initialize(file)
      if file.is_a? String
        @url = file
        http = logger.benchmark_info("Fetch #{file}") do
          http = @@faraday.get(file)
        end
        file = StringIO.new(http.body)
      end

      logger.benchmark_info("parse archive zip") do
        zip = Zip::InputStream.new(file)
        loop do
          zip_entry = zip.get_next_entry
          break if zip_entry.nil?
          next unless self.class::TARGET.select_file? zip_entry.name

          if FileList.where(path: zip_entry.name, source: self.class.source_id).exists?
            logger.info "already processed #{zip_entry.name}"
            next
          end

          #zip_entry.get_input_stream doesn't respond to seek
          nested_zip = StringIO.new(zip_entry.get_input_stream.read)
          self.class::TARGET.new(nested_zip, zip_entry.name).process
        end
      end
    end

    def process
      done!
    end
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

  class TradingArchive < Archive
    include SemanticLogger::Loggable

    URL = "https://nemweb.com.au/Reports/ARCHIVE/TradingIS_Reports/"
    TARGET = Trading
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
        Aemo::TradingMMS.new(date).process_price
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

          {time:, unit_id:, value:}
        end
      end
      #require 'pry' ; binding.pry

      r
    end
  end

  class ScadaArchive < Archive
    include SemanticLogger::Loggable

    URL = 'https://nemweb.com.au/Reports/ARCHIVE/Dispatch_SCADA/'
    TARGET = Scada
  end

  class ScadaMMS < Scada
    include SemanticLogger::Loggable

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

    def self.select_file? url
      super && url =~ /PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_/
    end
    def process_rows(all)
      r = {}
      all.select { |row| row[0..2] == ['D','ROOFTOP','ACTUAL'] && row[8] == 'MEASUREMENT' }.map do |row|
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
      end.compact
    end
    def points_generation
      @r
    end
  end

  class RooftopPvArchive < Archive
    include SemanticLogger::Loggable

    URL = "https://nemweb.com.au/Reports/ARCHIVE/ROOFTOP_PV/ACTUAL/"
    TARGET = RooftopPv

    def self.select_file? url
      super && url =~ /PUBLIC_ROOFTOP_PV_ACTUAL_MEASUREMENT_/
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
        Aemo::RooftopPvMMS.new(date).process
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
