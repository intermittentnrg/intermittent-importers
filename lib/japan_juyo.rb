# frozen_string_literal: true

require 'chronic'
require 'faraday'
require 'faraday/follow_redirects'
require 'csv'
require 'fileutils'

module JapanJuyo
  # Base class for all Juyo (demand/supply) CSV parsers
  class Base
    include SemanticLogger::Loggable

    TZ = TZInfo::Timezone.get('Asia/Tokyo')

    # Default row indices for CSV parsing (2nd table with 5-minute data)
    HEADER_ROW = 54
    DATA_START_ROW = 55
    DATA_END_ROW = DATA_START_ROW + 288

    # Whether this utility has wind data in column 4
    HAS_WIND = false

    def self.source_id
      self::SOURCE_ID
    end

    def initialize
      @r = []
      @r_load = []
      @datafiles = []
      @faraday = Faraday.new do |f|
        f.response :raise_error
      end
    end

    # Override in child classes that don't accept date
    def add(date)
      add_date(date)
    end

    def add_date(date, save_csv = false)
      @from = date
      url = date.strftime(self.class::URL_FORMAT)
      add_url(url, save_csv)
    end

    def add_url(url, save_csv = false)
      last_modified = DataFile.last_modified(url, self.class.source_id)
      res = logger.benchmark_info(url) do
        @faraday.get(url) do |req|
          req.headers['If-Modified-Since'] = last_modified if last_modified
        end
      end

      if res.status == 304
        logger.warn "304 Not Modified #{url}"
        return self
      end

      if res.headers['Last-Modified']
        filedate = Time.httpdate(res.headers['Last-Modified'])
        @datafiles << { path: File.basename(url), source: self.class.source_id, updated_at: filedate }
      end

      save_file(res.body, url) if save_csv

      if res.body.nil? || res.body.empty?
        logger.error "Empty response body from #{url}: status=#{res.status}, content-type=#{res.headers['Content-Type']}"
        raise ArgumentError, "Empty response body from #{url}"
      end

      add_buffer(res.body)
    end

    def done!
      return logger.info('no changes') if @datafiles.empty?

      Out::Generation.run(@r, @from, @to, self.class.source_id)
      Out::Load.run(@r_load, @from, @to, self.class.source_id)

      DataFile.upsert_all(@datafiles, unique_by: %i[source path])
      logger.info "done! #{File.basename(@datafiles.first[:path])}"
    end

    private

    def save_file(body, url)
      dir = File.join('data', self.class.source_id)
      FileUtils.mkdir_p(dir) unless Dir.exist?(dir)
      filepath = File.join(dir, File.basename(url))
      File.binwrite(filepath, body)
      logger.info "Saved #{filepath}"
    end

    def add_buffer(body)
      body = body.encode('UTF-8', 'Shift_JIS')
      csv = CSV.parse(body)

      header = csv[self.class::HEADER_ROW]
      rows = csv[self.class::DATA_START_ROW...self.class::DATA_END_ROW]

      if header.nil?
        logger.error "Unexpected CSV format from #{self.class::URL_FORMAT}. Body empty or too short: #{body.nil? ? 'nil' : body[0..500].inspect}, length=#{body&.length || 0}, CSV rows=#{csv.size}, expected header at row #{self.class::HEADER_ROW}"
        raise ArgumentError, 'Empty CSV or invalid format'
      end

      validate_header!(header)

      rows.each do |row|
        next if row.nil? || row[0].nil? || row[1].nil?

        time = parse_time(row)
        consumption = row[2].to_f * 10_000
        solar = row[3].to_f * 10_000

        @r_load << { country: self.class::COUNTRY, time: time, value: consumption }
        @r << { country: self.class::COUNTRY, time: time, production_type: 'solar', value: solar }

        if wind?
          wind = row[4].to_f * 10_000
          @r << { country: self.class::COUNTRY, time: time, production_type: 'wind', value: wind }
        end
      end

      self
    end

    def wind?
      self.class::HAS_WIND
    end

    def validate_header!(header)
      raise ArgumentError, 'Invalid header: expected DATE, TIME' unless header[0..1] == %w[DATE TIME]
      raise ArgumentError, 'Invalid header: missing 当日実績' unless header[2]&.include?('当日実績')
      raise ArgumentError, 'Invalid header: missing 太陽光発電' unless header[3]&.include?('太陽光発電')

      return unless wind?
      raise ArgumentError, 'Invalid header: missing 風力発電' unless header[4]&.include?('風力発電')
    end

    def parse_time(row)
      time = Time.strptime("#{row[0]} #{row[1]}", '%Y/%m/%d %H:%M')
      TZ.local_to_utc(time)
    end
  end

  # Snapshot-based parsers (live data only)
  module Snapshot
    def add(save_csv = false)
      add_url(self.class::URL, save_csv)
    end

    def self.included(base)
      base.include CliMixin2::SnapshotWithDownload
    end
  end

  # Daily parsers (historical data with date parameter)
  module Daily
    module ClassMethods
      def each(&block)
        from = ::Generation.joins(areas_production_type: :area)
                           .where('time > ?', 2.months.ago)
                           .where(area: { source: source_id })
                           .maximum(:time) || 1.day.ago
        to = Time.now
        logger.info("Refresh from #{from}")
        (from.to_date..to.to_date).each(&block)
      end
    end

    def add(date, save_csv = false)
      add_date(date, save_csv)
    end

    def self.included(base)
      base.extend ClassMethods
      base.include CliMixin2::DailyWithDownload
    end
  end

  # Individual utility implementations

  # Tokyo Electric Power Company (TEPCO) - Snapshot
  class Tepco < Base
    include Snapshot

    URL = 'https://www.tepco.co.jp/forecast/html/images/juyo-d1-j.csv'
    COUNTRY = 'tokyo'
    SOURCE_ID = 'tepco'
  end

  # Chubu Electric Power (Chuden) - Snapshot
  class Chuden < Base
    include Snapshot

    URL = 'https://powergrid.chuden.co.jp/denki_yoho_content_data/juyo_cepco003.csv'
    COUNTRY = 'chubu'
    SOURCE_ID = 'chuden'
  end

  # Tohoku Electric Power - Daily
  class Tohoku < Base
    include Daily

    # Supports historical data
    URL_FORMAT = 'https://setsuden.nw.tohoku-epco.co.jp/common/demand/juyo_02_%Y%m%d.csv'
    COUNTRY = 'tohoku'
    HAS_WIND = true
    SOURCE_ID = 'tohoku-epco'
  end

  # Hokkaido Electric Power (Hepco) - Daily
  class Hepco < Base
    include Daily

    # Limited historical data - only today and yesterday available
    URL_FORMAT = 'http://denkiyoho.hepco.co.jp/area/data/juyo_01_%Y%m%d.csv'
    COUNTRY = 'hokkaido'
    SOURCE_ID = 'hepco'
  end

  # Hokuriku Electric Power (Rikuden) - Daily
  class Rikuden < Base
    include Daily

    # Supports historical data
    URL_FORMAT = 'http://www.rikuden.co.jp/nw/denki-yoho/csv/juyo_05_%Y%m%d.csv'
    COUNTRY = 'hokuriku'
    SOURCE_ID = 'rikuden'
  end

  # Okinawa Electric Power (Okiden) - Daily
  class Okiden < Base
    include Daily

    # Supports historical data
    URL_FORMAT = 'https://www.okiden.co.jp/denki2/juyo_10_%Y%m%d.csv'
    COUNTRY = 'okinawa'
    SOURCE_ID = 'okiden'
  end

  # Chugoku Electric Power - Daily
  class Chugoku < Base
    include Daily

    # Supports historical data
    URL_FORMAT = 'https://www.energia.co.jp/nw/jukyuu/sys/juyo_07_%Y%m%d.csv'
    COUNTRY = 'chugoku'
    SOURCE_ID = 'chugoku'
  end

  # Shikoku Electric Power (Yonden) - Snapshot
  class Yonden < Base
    include Snapshot

    URL = 'https://www.yonden.co.jp/denkiyoho/juyo_shikoku.csv'
    COUNTRY = 'shikoku'
    SOURCE_ID = 'yonden'
  end

  # Kyushu Electric Power (Kyuden) - Daily
  # http://www.kyuden.co.jp/power_usages/pc.html
  class Kyuden < Base
    include Daily

    # Supports historical data
    URL_FORMAT = 'https://www.kyuden.co.jp/td_power_usages/csv/juyo-hourly-%Y%m%d.csv'
    COUNTRY = 'kyushu'
    SOURCE_ID = 'kyuden'
  end

  # Kansai Electric Power (Kepco) - Snapshot
  class Kepco < Base
    include Snapshot

    URL = 'https://www.kansai-td.co.jp/yamasou/juyo1_kansai.csv'
    COUNTRY = 'kansai'
    SOURCE_ID = 'kepco'

    # Kansai uses different row indices
    HEADER_ROW = 57
    DATA_START_ROW = 58
    DATA_END_ROW = DATA_START_ROW + 288
  end
end
