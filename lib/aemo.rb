require 'faraday-http-cache'
require 'faraday/net_http_persistent'
require 'zip'
require 'csv'

module Aemo
  class Base
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

      http.body.split(/<br>/).each do |row|
        m = row.match(/(.*)\s+\d+\s+<A HREF="(.*?)"/)
        next unless m
        next unless select_file?(m[2])
        url = self::URL_BASE + m[2]
        time = Time.strptime(m[1].strip, self::INDEX_TIME_FORMAT)
        time = self::TZ.local_to_utc(time)

        if DataFile.where(updated_at: time...Float::INFINITY, path: File.basename(url), source: self.source_id).exists?
          logger.debug "already processed #{File.basename(url)}"
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

      if @url =~ /\.zip$/
        zip = Zip::InputStream.new(file)
        @r = []
        while zip.get_next_entry
          body = zip.read
          csv = CSV.new(body)
          @r += process_rows(csv.to_a)
       end
      else
        csv = CSV.new(file)
        @r = process_rows(csv.to_a)
      end

      #require 'pry' ; binding.pry

    end

    def process
      done!
    end
    def done!
      DataFile.upsert({path: File.basename(@url), source: self.class.source_id}, unique_by: [:source, :path])
      logger.info "done! #{@url}"
    end

    ROW_TIME_FORMAT = '%Y/%m/%d %H:%M:%S'
    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = self.class::TZ.local_to_utc(Time.strptime(s, self.class::ROW_TIME_FORMAT))
    end

    def points_price
      @r
    end
    def points_generation
      @r
    end
    def points_load
      @r
    end
    def points
      @r
    end
  end
end
