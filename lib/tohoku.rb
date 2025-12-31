require 'chronic'
require 'faraday'
require 'csv'

module Tohoku
  class Juyo
    include SemanticLogger::Loggable
    TZ = TZInfo::Timezone.get('Asia/Tokyo')
    HTTP_DATE_FORMAT = '%a, %d %b %Y %H:%M:%S GMT'
    def self.source_id
      "tohoku-epco"
    end

    def self.cli(args)
      if args.length == 1
        date = Chronic.parse(args[0]).to_date
        new.add_date(date).done!
      elsif args.length == 2
        from = Chronic.parse(args[0]).to_date
        to = Chronic.parse(args[1]).to_date
        (from..to).each do |date|
          new.add_date(date).done!
        end
      end
    end

    def self.each
      from = ::Generation.joins(:areas_production_type => :area).where("time > ?", 2.months.ago).where(area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield date
      end
    end

    def initialize
      @r = []
      @r_load = []
    end

    def add(date)
      add_date(date)
    end

    def add_date(date)
      @from = date
      @url = "https://setsuden.nw.tohoku-epco.co.jp/common/demand/juyo_02_#{@from.strftime('%Y%m%d')}.csv"

      add_url(@url)
    end

    def add_url(url)
      last_modified = DataFile.last_modified(url, self.class.source_id)
      res = logger.benchmark_info(url) do
        Faraday.get(url) do |req|
          req.headers['If-Modified-Since'] = last_modified if last_modified
        end
      end
      if res.status == 304 #Not Modified
        raise EmptyError
      end
      @filedate = Time.strptime(res.headers['Last-Modified'], HTTP_DATE_FORMAT)

      add_buffer(res.body)
    end

    def add_buffer(body)
      csv = CSV.parse(body.encode('UTF-8'))
      rows = csv[54..]
      row = rows.shift
      raise unless row[0..1] == ["DATE", "TIME"] && row[2].include?('当日実績') && row[3].include?('太陽光発電') && row[4].include?('風力発電')
      rows.each do |row|
        time = Time.strptime("#{row[0]} #{row[1]}", '%Y/%m/%d %H:%M')
        time = TZ.local_to_utc(time)
        @r_load << {country: 'tohoku', time:, value: row[2].to_f*10000}
        @r << {country: 'tohoku', production_type: 'solar', time:, value: row[3].to_f*10000}
        @r << {country: 'tohoku', production_type: 'wind', time:, value: row[4].to_f*10000}
      end

      self
    end

    def done!
      return if @r.empty? && @r_load.empty?

      @from = TZ.local_to_utc(@from.to_time)
      @to = @from + 1.day

      Out::Generation.run(@r, @from, @to, self.class.source_id)
      Out::Load.run(@r_load, @from, @to, self.class.source_id)

      DataFile.upsert({path: File.basename(@url), source: self.class.source_id, updated_at: @filedate}, unique_by: [:source, :path])
      logger.info "done! #{File.basename(@url)}"
    end
  end
end
