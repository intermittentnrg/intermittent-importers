Time.zone = "Europe/Stockholm"
class Nordpool
  class Base
    def initialize(date)
    end
    def self.source_id
      "nordpool"
    end
  end
  class PriceSEK < Base
    def self.source_id
      "nordpool_sek"
    end
    def initialize(date)
      @options = {}
      @options[:endDate] = date.strftime('%d-%m-%Y')
      @options[:currency] = ',SEK,SEK,EUR'
      @res = HTTParty.get(
        "https://www.nordpoolgroup.com/api/marketdata/page/29",
        query: @options,
        debug_output: $stdout
      )
      puts @res.body
    end
    def points
      r = []
      rows = @res.parsed_response["data"]["Rows"].filter { |row| !row["IsNtcRow"] && !row["IsExtraRow"] }
      #require 'pry' ; binding.pry
      rows.each do |row|
        time = Time.zone.strptime row["StartTime"], '%Y-%m-%dT%H:%M:%S'
        puts "#{row["StartTime"]} = #{time}"
        row["Columns"].each do |c|
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
  class Transmission < Base
    URL = 'https://www.nordpoolgroup.com/api/marketdata/page/169'
    FIELD = :value
    def initialize(date)
      @options = {}
      @options[:endDate] = date.strftime('%d-%m-%Y')
      @res = HTTParty.get(
        URL,
        query: @options,
        #debug_output: $stdout
      )
      #puts @res.body
    end
    def points
      r = []
      rows = @res.parsed_response["data"]["Rows"].filter { |row| !row["IsNtcRow"] && !row["IsExtraRow"] }
      rows.each do |row|
        time = Time.zone.strptime row["StartTime"], '%Y-%m-%dT%H:%M:%S'
        row["Columns"].each do |c|
          next if c["Name"].include? '+'
          next if c["Value"] == "-"
          from,to = c["Name"].split(/ ?> /)
          r << {
            :time => time,
            :from_country => from,
            :to_country => to,
            FIELD => c["Value"].gsub(/\s/, '').gsub(/,/,'.')
          }
        end
      end

      r
    end
  end
  class Capacity < Transmission
    URL = "https://www.nordpoolgroup.com/api/marketdata/page/484060"
    FIELD = :capacity
  end
end
