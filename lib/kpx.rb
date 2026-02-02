require 'chronic'
require 'nokogiri'
require 'faraday/cookie_jar'
require 'faraday/net_http_persistent'

module Kpx
  class Base
    TZ = TZInfo::Timezone.get('Asia/Seoul')
    SOURCE_ID = 'kpx'

    PRODUCTION_MAPPING = {
      'coal' => :fossil_coal,
      'localCoal' => :fossil_coal,
      'gas' => :fossil_gas,
      'oil' => :fossil_oil,
      'nuclearPower' => :nuclear,
      'waterPower' => :hydro,
      'windPower' => :wind,
      'sunlight' => :solar,
      'newRenewable' => :other_renewable,
      'raisingWater' => :hydro_pumped_storage
    }

    def self.source_id
      SOURCE_ID
    end

    def add_json(json)
      json.each do |item|
        break if item['regDate'] == '0' || item['regDate'].nil?

        time = Time.strptime(item['regDate'], '%Y-%m-%d %H:%M')
        time = TZ.local_to_utc(time)

        @from = [@from, time].compact.min
        @to = [@to, time].compact.max

        item.each do |key, value|
          production_type = PRODUCTION_MAPPING[key]
          if production_type
            value = value.to_f * 1000

            k = [time, 'KR', production_type]
            if @r[k]
              @r[k][:value] += value
            else
              @r[k] = {
                time:,
                country: 'KR',
                production_type:,
                value:
              }
            end
          end
        end
      end
    end

    def add_buffer(body, name = nil, updated_at = nil)
      doc = Nokogiri::HTML(body)

      script_content = doc.css('script').map(&:text).find { |text| text.include?('var ictArr = ') }
      raise "Could not find ictArr data in response" unless script_content

      json_match = script_content.match(/var ictArr = (\[\{.*\}\]);/m)
      raise "Could not parse ictArr JSON data" unless json_match

      data = JSON.parse(json_match[1])
      add_json(data)

      self
    end

  end

  class Generation < Base
    include SemanticLogger::Loggable

    URL = "https://new.kpx.or.kr/powerinfoSubmain.es?mid=a10606030000"

    def initialize
      @r = {}
      @from = nil
      @to = nil
    end

    def self.cli(args)
      raise "No arguments allowed" if args.any?
      new.add.done!
    end

    def add
      response = Faraday.get(URL)
      add_buffer(response.body)
      self
    end

    def done!
      unless @r.empty?
        Out::Generation.run(@r.values, @from, @to, self.class.source_id)
      end
    end
  end

  class GenerationHistory < Base
    include SemanticLogger::Loggable

    URL = "https://new.kpx.or.kr/powerSource.es?mid=a10606030000&device=chart"

    def initialize
      @r = {}
      @from = nil
      @to = nil
      @conn = nil
      @cookie_jar = nil
    end

    def self.cli(args)
      raise "Arguments required" if args.empty?
      from = Chronic.parse(args[0]).to_date
      to = Chronic.parse(args[1] || args[0]).to_date
      instance = new
      (from..to).each do |date|
        instance.add_date(date)
      end
      instance.done!
    end

    def add_date(date)
      @from = [@from, date.to_time.utc].compact.min
      @to = [@to, (date + 1.day).to_time.utc].compact.max

      # Create connection on first call
      unless @conn
        @cookie_jar = HTTP::CookieJar.new
        @conn = Faraday.new do |f|
          f.use :cookie_jar, jar: @cookie_jar
          f.request :url_encoded
          f.adapter :net_http_persistent
        end
        # Initial GET to establish session
        @conn.get(URL)
      end

      # API only supports single date (both from/to set to same date)
      date_str = date.strftime('%Y-%m-%d')

      # Extract XSRF-TOKEN from cookie jar
      csrf_token = nil
      @cookie_jar.cookies.each do |cookie|
        if cookie.name == 'XSRF-TOKEN'
          csrf_token = cookie.value
          break
        end
      end

      payload = {
        mid: 'a10606030000',
        device: 'chart',
        view_sdate: date_str,
        view_edate: date_str,
        _csrf: csrf_token
      }

      # POST - cookies sent automatically by cookie_jar
      response = @conn.post(URL, payload)
      add_buffer(response.body)

      self
    end

    def done!
      unless @r.empty?
        Out::Generation.run(@r.values, @from, @to, self.class.source_id)
      end
    end
  end

  class Price
    include SemanticLogger::Loggable

    URL = "https://new.kpx.or.kr/smpInland.es?mid=a10606080100&device=pc"
    CURRENCY = "KRW"

    def initialize
      @r = []
      @from = nil
      @to = nil
    end

    def self.cli(args)
      raise "No arguments allowed" if args.any?
      new.add.done!
    end

    def add
      response = Faraday.get(URL)
      add_buffer(response.body)
      self
    end

    def add_buffer(body, name = nil, updated_at = nil)
      doc = Nokogiri::HTML(body)

      # Find the price table - it's the first table with numeric data
      table = doc.css('table').find { |t| t.at('td') }
      raise "Could not find price table in response" unless table

      # Parse the header row to get dates
      header_cells = table.css('thead th')
      dates = []

      header_cells.each_with_index do |cell, idx|
        next if idx == 0  # Skip first column (hour label)
        # Date format: "01.28<br/>(수)" or "01.28 (수)"
        date_text = cell.text.strip.match(/(\d{2})\.(\d{2})/)
        if date_text
          month = date_text[1].to_i
          day = date_text[2].to_i
          # Use current year
          year = Time.now.utc.in_time_zone(Base::TZ).year
          dates << Date.new(year, month, day)
        end
      end

      # Parse the data rows
      rows = table.css('tbody tr, tr')[1..-1] || table.css('tr')[1..-1]

      rows.each do |row|
        cells = row.css('td')
        next if cells.empty?

        # First cell is the hour (1-24)
        hour_text = cells[0].text.strip
        next unless hour_text =~ /\d+/

        hour = hour_text.to_i

        # Process each day column
        cells[1..-1].each_with_index do |cell, col_idx|
          break if col_idx >= dates.length  # Safety check

          value_text = cell.text.strip.gsub(',', '')
          next if value_text.empty?

          price_value = value_text.to_f
          next if price_value == 0

          # Convert from Won/kWh to Won/MWh (multiply by 1000)
          # Then from Won to jeon/cents (multiply by 100)
          price_value *= 1000 * 100

          date = dates[col_idx]

          # Handle hour 24 rolling over to next day (like Python code)
          if hour == 24
            hour = 0
            date = date + 1.day
          end

          time = Time.utc(date.year, date.month, date.day, hour, 0)

          @from = [@from, time].compact.min
          @to = [@to, time].compact.max

          @r << {
            time: time,
            country: 'KR',
            value: price_value
          }
        end
      end

      self
    end

    def done!
      return if @r.empty?
      Out::Price.run(@r, @from, @to, self.class.source_id)
    end

    def self.source_id
      Base.source_id
    end
  end
end
