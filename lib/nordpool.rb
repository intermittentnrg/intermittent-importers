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
    def initialize(date)
      @options = {}
      @options[:endDate] = date.strftime('%d-%m-%Y')
      @options[:currency] = ',#{self.class::CURRENCY},#{self.class::CURRENCY},EUR'
      @res = HTTParty.get(
        "https://www.nordpoolgroup.com/api/marketdata/page/29",
        query: @options,
        #debug_output: $stdout
      )
      #puts @res.body
      raise @res.body if @res.parsed_response["ExceptionMessage"]
    end
    def points
      r = []
      rows = @res.parsed_response["data"]["Rows"].filter { |row| !row["IsNtcRow"] && !row["IsExtraRow"] }
      #require 'pry' ; binding.pry
      leap=0
      rows.each do |row|
        time = DateTime.strptime row["StartTime"], '%Y-%m-%dT%H:%M:%S'
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
    CURRENCY = 'SEK'
    def self.source_id
      "nordpool_sek"
    end
  end

  class Transmission < Base
    URL = 'https://www.nordpoolgroup.com/api/marketdata/page/169'
    FIELD = :value
    def initialize(date)
      @options = {}
      @options[:endDate] = date.strftime('%d-%m-%Y')
      @res = HTTParty.get(
        self.class::URL,
        query: @options,
        #headers: {"User-Agent" => "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/52.0.2743.116 Safari/537.36 Edge/15.15063"},
        headers: {"User-Agent" => "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:105.0) Gecko/20100101 Firefox/105.0"},
        #debug_output: $stdout
      )
      #puts @res.body
      raise @res.body if @res.parsed_response["ExceptionMessage"]
    end
    def points
      r = []
      rows = @res.parsed_response["data"]["Rows"].filter { |row| !row["IsNtcRow"] && !row["IsExtraRow"] }
      leap=0
      rows.each do |row|
        time = DateTime.strptime row["StartTime"], '%Y-%m-%dT%H:%M:%S'
        begin
          time = TZ.local_to_utc(time) { |periods| periods[leap].tap { leap += 1 } }
        rescue TZInfo::PeriodNotFound
          next
        end
        row["Columns"].each do |c|
          next if c["Name"].include? '+'
          next if c["Value"].start_with?("-")
          from,to = c["Name"].split(/ ?> /)
          raise if from=='PLC' || to=='PLC'
          r << {
            :time => time,
            :from_area => from,
            :to_area => to,
            self.class::FIELD => c["Value"].gsub(/\s/, '').gsub(/,/,'.')
          }
        end
      end
      #require 'pry' ; binding.pry
      r
    end
  end
  class Capacity < Transmission
    URL = "https://www.nordpoolgroup.com/api/marketdata/page/484060"
    FIELD = :capacity
  end
end
