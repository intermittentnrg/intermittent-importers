# frozen_string_literal: true

require 'faraday'
require 'time'
require 'cgi'

module JapanNuclear
  # https://www.kyuden.co.jp/business_outline/power.html
  # https://www.kyuden.co.jp/php/nuclear/genkai/g_power.php
  # https://www.kyuden.co.jp/php/nuclear/sendai/s_power.php
  # UNIT: 万kW = 10,000kW
  class Kyuden < Base
    SENDAI_URL = 'https://www.kyuden.co.jp/php/nuclear/sendai/rename.php?A=s_power.fdat&B=ncp_state.fdat&_=1520532401043'
    GENKAI_URL = 'https://www.kyuden.co.jp/php/nuclear/genkai/rename.php?A=g_power.fdat&B=ncp_state.fdat&_=1520532904073'
    SOURCE_ID = 'kyuden'

    def add(_save_images = false)
      country = 'kyushu'
      sendai_time, sendai_total = fetch_nuclear_plant_detailed(SENDAI_URL, country, 'sendai')
      genkai_time, genkai_total = fetch_nuclear_plant_detailed(GENKAI_URL, country, 'genkai')

      if sendai_time.nil? || genkai_time.nil? || sendai_time != genkai_time
        logger.error "Timestamp parsing failed or timestamps don't match: Sendai=#{sendai_time}, Genkai=#{genkai_time}"
      end

      @r_gen << {
        time: sendai_time,
        country:,
        production_type: 'nuclear',
        value: sendai_total + genkai_total
      }

      self
    end

    private

    def fetch_nuclear_plant_detailed(url, country, plant_name)
      response = @faraday.get(url)
      text = response.body.encode('UTF-8', 'Shift_JIS')

      params = CGI.parse(text).transform_values(&:first)

      lastupdate = params['lastupdate']
      year, month, day, hour, minute = lastupdate.scan(/[\d]+/).map(&:to_i)
      time = TZ.local_to_utc(Time.new(year, month, day, hour, minute))

      total = 0
      params.each do |key, value|
        next unless (match = key.match(/^[sg]_power_(\d+)gouki$/)) && value =~ /\A[\d.]+\z/

        unit_num = match[1]
        value = value.to_f * 10_000
        total += value

        @r_units << {
          time:,
          country:,
          unit: "#{plant_name}-#{unit_num}",
          production_type: 'nuclear',
          value: value
        }
      end

      [time, total]
    end
  end
end
