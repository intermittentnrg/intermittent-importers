require 'faraday-http-cache'

module Aemo
  class Base
    TZ = TZInfo::Timezone.get('Etc/GMT+10')
    URL_BASE = "https://nemweb.com.au"

    def self.source_id
      'aemo'
    end

    def initialize
      @store = ActiveSupport::Cache::FileStore.new "tmp/"
      @faraday = Faraday.new do |f|
        f.use :http_cache, store: @store, serializer: Marshal
        #f.response :logger, logger
      end
    end

    def process_index
      logger.info("Fetch #{self.class::URL}")
      http = @faraday.get(self.class::URL)
      links = http.body.scan /HREF="(.*?)"/
      links.select! { |url| url.first =~ /.zip$/i }

      r = []
      links.first(1).each do |url|
        r << process_file(URL_BASE + url.first)
      end
      r.flatten!
    end

    def process_file(url)
      logger.info("Fetch #{url}")
      http = @faraday.get(url)
      zip = Zip::InputStream.new(StringIO.new(http.body))
      zip.get_next_entry
      body = zip.read
      csv = CSV.new(body)

      all = csv.to_a

      #r = all.select { |r| r[0..2] == ['D','TRADING','PRICE'] }.map do |r|
      all.select(&method(:select_csv_rows)).map do |row|
        # I
        # TRADING
        # PRICE
        # 3
        # SETTLEMENTDATE
        time = TZ.local_to_utc(Time.strptime(row[4], '%Y/%m/%d %H:%M:%S'))
        # RUNNO
        # REGIONID
        country = row[6]
        # PERIODID
        # RRP
        value = row[8]
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

        {
          time:, country:, value:
        }
      end
    end
    def points_price
      process_index
    end
  end

  class Dispatch < Base
    include SemanticLogger::Loggable
    include Out::Price

    URL = "https://nemweb.com.au/Reports/Current/DispatchIS_Reports/"

    def select_csv_rows(row)
      row[0..2] == ['D','DISPATCH','PRICE']
    end
  end

  class Trading < Base
    include SemanticLogger::Loggable
    include Out::Price

    URL = "https://nemweb.com.au/Reports/Current/TradingIS_Reports/"

    def select_csv_rows(r)
      r[0..2] == ['D','TRADING','PRICE']
    end
  end
end
