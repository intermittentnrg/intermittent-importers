module Tohoku
  class Juyo
    include SemanticLogger::Loggable
    TZ = TZInfo::Timezone.get('Asia/Tokyo')
    def self.source_id
      "tohoku-epco"
    end

    def self.cli(args)
      if args.length == 1
        date = Chronic.parse(args[0]).to_date
        new(date).process
      elsif args.length == 2
        from = Chronic.parse(args[0]).to_date
        to = Chronic.parse(args[1]).to_date
        (from..to).each do |date|
          new(date).process
        end
      end
    end

    def self.parsers_each
      from = ::Generation.joins(:area).where("time > ?", 2.months.ago).where(area: {source: self.source_id}).maximum(:time).in_time_zone(self::TZ)
      to = Time.now.in_time_zone(self::TZ)
      logger.info("Refresh from #{from}")
      (from.to_date..to.to_date).each do |date|
        yield self.new date
      end
    end

    def initialize(date)
      @from = date
    end

    def fetch
      return if @csv
      url = "https://setsuden.nw.tohoku-epco.co.jp/common/demand/juyo_02_#{@from.strftime('%Y%m%d')}.csv"
      res = Faraday.get(url)
      @csv = CSV.parse(res.body.encode('UTF-8'))
      #require 'pry' ; binding.pry
    end

    def process
      fetch
      rows = @csv[54..]
      row = rows.shift
      raise unless row[0..1] == ["DATE", "TIME"] && row[2].include?('当日実績') && row[3].include?('太陽光発電') && row[4].include?('風力発電')
      r = []
      r_load = []
      rows.each do |row|
        time = Time.strptime("#{row[0]} #{row[1]}", '%Y/%m/%d %H:%M')
        time = TZ.local_to_utc(time)
        r_load << {country: 'tohoku', time:, value: row[2].to_f*10000}
        r << {country: 'tohoku', production_type: 'solar', time:, value: row[3].to_f*10000}
        r << {country: 'tohoku', production_type: 'wind', time:, value: row[4].to_f*10000}
      end

      @from = TZ.local_to_utc(@from.to_time)
      @to = @from + 1.day
      #require 'pry' ; binding.pry

      Out2::Generation.run(r, @from, @to, self.class.source_id)
      Out2::Load.run(r_load, @from, @to, self.class.source_id)
    end
  end
end
