# frozen_string_literal: true

require 'faraday/net_http_persistent'
require 'zip'
require 'fastest_csv'

module Aemo
  class Base
    include SemanticLogger::Loggable

    @@faraday = Faraday.new do |f|
      f.adapter :net_http_persistent
      f.response :raise_error
      # f.response :logger, logger
    end

    def self.source_id
      'aemo'
    end

    def self.select_file?(url)
      url =~ /.zip$/i
    end

    def self.each
      logger.info("Fetch #{self::URL}")
      res = @@faraday.get(self::URL)

      res.body.split(/<br>/).each do |row|
        m = row.match(/(.*)\s+\d+\s+<A HREF="(.*?)"/)
        next unless m
        next unless select_file?(m[2])

        url = self::URL_BASE + m[2]
        time = Time.strptime(m[1].strip, self::INDEX_TIME_FORMAT)
        time = self::TZ.local_to_utc(time)

        if DataFile.where(updated_at: time...Float::INFINITY, path: File.basename(url), source: source_id).exists?
          logger.debug "already processed #{File.basename(url)}"
          next
        end
        yield url
      end

      nil
    end

    def initialize
      @datafiles = []
    end

    HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
    def add(input)
      add_url(input)
    end

    def add_url(url)
      last_modified = DataFile.last_modified(url, self.class.source_id)
      res = logger.benchmark_info("Fetch #{url}") do
        @@faraday.get(url) do |req|
          req.headers['If-Modified-Since'] = last_modified if last_modified
        end
      end
      raise EmptyError if res.status == 304 # Not Modified

      last_modified = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)
      add_buffer(res.body, url, last_modified)

      self
    end

    def add_file(path)
      file = File.open(path)
      add_buffer(file.read, path, file.mtime)

      self
    end

    def add_buffer(data, name, date)
      if name =~ /\.zip$/
        Zip::File.open_buffer(data) do |zip|
          raise 'FIXME' unless zip.count == 1

          zip_entry = zip.entries.first
          data = zip_entry.get_input_stream.read
          # name = zip_entry.name
          date = zip_entry.mtime
        end
      end
      parse_filename!(name)

      @datafiles << { path: File.basename(name), updated_at: date, source: self.class.source_id }
      add_buffer2(data)

      self
    end

    def add_buffer2(data)
      add_csv(FastestCSV.parse(data, row_sep: "\r\n"))
    end

    def done!
      DataFile.upsert_all(@datafiles, unique_by: %i[source path])
      datafiles = @datafiles.map { |datafile| datafile[:path] }.join ', '
      logger.info "done! #{datafiles}"
    end

    ROW_TIME_FORMAT = '%Y/%m/%d %H:%M:%S'
    def parse_time(s)
      return @last_t if @last_s == s

      @last_s = s
      @last_t = self.class::TZ.local_to_utc(Time.strptime(s, self.class::ROW_TIME_FORMAT))
    end

    def points_load
      @r
    end

    def points
      @r
    end
  end
end
