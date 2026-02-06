# frozen_string_literal: true

require 'faraday'
require 'faraday/follow_redirects'
require 'nokogiri'

module JapanNuclear
  class Kepco < Base
    URL = 'https://www.kepco.co.jp/energy_supply/energy/nuclear_power/info/monitor/live_unten/'
    IMG_URL = 'https://www.kepco.co.jp'
    SOURCE_ID = 'kepco'

    def add(_save_images = false)
      country = 'kansai'
      doc = Nokogiri::HTML(@faraday.get(URL).body)
      time = extract_time(doc)

      total = 0
      doc.css('table').each do |unit_table|
        plant_img = unit_table.css('th img').first
        plant = File.basename(plant_img['src']).split(/_/).first

        unit_table.css('tr:has(td.list02)').each do |tr|
          capacity = tr.css('td.list03').first.text
          raise capacity unless capacity.include?('万')

          capacity = capacity.split('万').first.to_f * 10_000

          # Get percentage from gif images
          percentage = nil
          tr.css('img').each do |img|
            next unless img['src']&.include?('.gif')

            text = ocr_image(IMG_URL + img['src'])
            digits = text.scan(/\d+/)
            percentage = digits.first.to_f / 100.0 if digits.any?
            break if percentage
          end
          next unless percentage

          value = capacity * percentage

          # Get unit ID
          unit_num = tr.css('td.list02').first&.text&.to_i
          raise unless unit_num

          @r_units << {
            time:,
            country:,
            unit: "#{plant}-#{unit_num}",
            production_type: 'nuclear',
            value: value
          }
          total += value
        end
      end

      @r_gen << {
        time:,
        country:,
        production_type: 'nuclear',
        value: total
      }

      self
    end

    private

    def extract_time(doc)
      img = doc.css('img.time-data').first

      text = ocr_image(IMG_URL + img['src'])

      month, day, hour, minute = text.scan(/[\d]+/).map(&:to_i)
      # Using current year as we only have month/day from OCR
      time = Time.new(Time.now.year, month, day, hour, minute)
      TZ.local_to_utc(time)
    end
  end
end
