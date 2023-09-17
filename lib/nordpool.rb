require 'httparty'

class Nordpool
  class Base
    TZ = TZInfo::Timezone.get('Europe/Stockholm')
    CURRENCY = 'EUR'

    def initialize(date)
    end
    def self.source_id
      "nordpool"
    end
  end

  class Price < Base
    include SemanticLogger::Loggable
    include Out::Price

    def self.parsers_each(&block)
      from = ::Price.joins(:area).group(:'area.code').where(area: {source: self.source_id}).pluck(Arel.sql("LAST(time, time)")).min.try(:to_datetime).try(:next_day)
      from ||= Date.parse("2021-10-01")
      to = 2.days.from_now
      #require 'pry' ; binding.pry
      (from..to).each do |date|
        yield self.new date
      end
    end

    def initialize(date)
      @from = TZ.local_to_utc(date)
      @to = @from + 1.day
      @options = {}
      @options[:endDate] = date.strftime('%d-%m-%Y')
      @options[:currency] = ",#{self.class::CURRENCY},#{self.class::CURRENCY},EUR"
      url = "https://www.nordpoolgroup.com/api/marketdata/page/29"
      @res = logger.benchmark_info(url) do
        HTTParty.get(
          url,
          query: @options,
          headers: {"User-Agent" => "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105.0"},
          #debug_output: $stdout
        )
      end
      #puts @res.body
      raise @res.body if @res.parsed_response["ExceptionMessage"]
    end
    def points
      points_price
    end
    def points_price
      r = []
      rows = @res.parsed_response["data"]["Rows"].filter { |row| !row["IsNtcRow"] && !row["IsExtraRow"] }
      #require 'pry' ; binding.pry
      leap=0
      rows.each do |row|
        time = Time.strptime row["StartTime"], '%Y-%m-%dT%H:%M:%S'
        begin
          time = TZ.local_to_utc(time) { |periods| periods[leap].tap { leap += 1 } }
        rescue TZInfo::PeriodNotFound
          next
        end
        #puts "#{row["StartTime"]} = #{time}"
        row["Columns"].each do |c|
          next if c["Value"] == "-"
          r << {
            time: time,
            country: c["Name"],
            value: c["Value"].gsub(/\s/, '').gsub(/,/,'.').to_f
          }
        end
      end

      r
    end
  end

  class PriceSEK < Price
    include SemanticLogger::Loggable

    CURRENCY = 'SEK'
    def self.source_id
      "nordpool_sek"
    end
  end

  class Transmission < Base
    include SemanticLogger::Loggable
    include Out::Transmission

    def self.parsers_each(&block)
      from = ::Transmission.joins(:from_area).group(:'from_area.code').where('value IS NOT NULL').where(from_area: {source: self.source_id}).where("time > '2022-10-05'").pluck(Arel.sql("LAST(time, time)")).min.try(:to_datetime).try(:next_day)
      from ||= Date.parse("2021-10-01")
      to = 2.days.from_now
      (from..to).each do |date|
        #require 'pry' ; binding.pry
        yield Nordpool::Transmission.new(date)
      end
    end

    # this has more data?
    #      https://www.nordpoolgroup.com/api/marketdata/page/165
    URL = 'https://www.nordpoolgroup.com/api/marketdata/page/169'
    FIELD = :value
    def initialize(date)
      @from = TZ.local_to_utc(date.to_time)
      @to = @from + 1.day
      @options = {}
      @options[:endDate] = date.strftime('%d-%m-%Y')
      @res = logger.benchmark_info(self.class::URL) do
        HTTParty.get(
          self.class::URL,
          query: @options,
          headers: {"User-Agent" => "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105.0"},
          #debug_output: $stdout
        )
      end
      #puts @res.body
      raise @res.body if @res.parsed_response["ExceptionMessage"]
    end
    def points
      r = []
      rows = @res.parsed_response["data"]["Rows"].filter { |row| !row["IsNtcRow"] && !row["IsExtraRow"] }
      leap=0
      rows.each do |row|
        time = Time.strptime row["StartTime"], '%Y-%m-%dT%H:%M:%S'
        begin
          time = TZ.local_to_utc(time) { |periods| periods[leap].tap { leap += 1 } }
        rescue TZInfo::PeriodNotFound
          next
        end
        row["Columns"].each do |c|
          next if c["Name"].include? '+'
          next if c["Value"].start_with?("-")
          from,to = c["Name"].split(/ *> /)
          #raise if from=='PLC' || to=='PLC'
          r << {
            :time => time,
            :from_area => from,
            :to_area => to,
            self.class::FIELD => c["Value"].gsub(/\s/, '').gsub(/,/,'.').to_i*1000
          }
        end
      end
      #require 'pry' ; binding.pry
      r
    end
  end

  class Capacity < Transmission
    include SemanticLogger::Loggable
    include Out::Capacity

    URL = "https://www.nordpoolgroup.com/api/marketdata/page/484060"
    FIELD = :capacity

    def self.cli(args)
      if args.length < 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      areas = {}
      (from...to).each do |time|
        e = Nordpool::Capacity.new(time)
        e.process
      end
    end
  end

  class CapacityChart < Capacity
    include SemanticLogger::Loggable

    URL = "https://www.nordpoolgroup.com/api/marketdata/chart/503617"

    def self.cli(args)
      if args.length < 2
        $stderr.puts "#{$0} <from> <to>"
        exit 1
      end
      from = Chronic.parse(args.shift).to_date
      to = Chronic.parse(args.shift).to_date

      areas = {}
      time = from
      loop do
        e = Nordpool::CapacityChart.new(time)

        points = e.points
        points.each do |p|
          p[:from_area_id] = areas[p[:from_area]] ||= Area.where(source: Nordpool::Capacity.source_id, code: p[:from_area], region: 'europe').pluck(:id).first
          p[:to_area_id] = areas[p[:to_area]] ||= Area.where(source: Nordpool::Capacity.source_id, code: p[:to_area], region: 'europe').pluck(:id).first
          raise p.inspect unless p[:from_area_id] && p[:to_area_id]
          p.delete :from_area
          p.delete :to_area
        end
        #puts points
        #require 'pry' ; binding.pry
        ::Transmission.upsert_all points
        puts "break if #{time} > #{to}"
        break if time >= to
        time += 7.days
      end
    end
  end
end
