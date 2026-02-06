# frozen_string_literal: true

require 'nokogiri'
require 'date'

module JapanNuclear
  class Yonden < Base
    REPORT_URL = 'https://www.yonden.co.jp/energy/atom/ikata/ikt722.html'
    IMAGE_URL = 'https://www.yonden.co.jp/energy/atom/ikata/'
    SOURCE_ID = 'yonden'

    def add(_save_images = false)
      country = 'shikoku'
      doc = Nokogiri::HTML(@faraday.get(REPORT_URL).body)

      time = extract_time(doc)
      value = extract_power(doc)

      @r_units << {
        time:,
        country:,
        unit: 'ikata-3',
        production_type: 'nuclear',
        value:
      }
      @r_gen << {
        time:,
        country:,
        production_type: 'nuclear',
        value:
      }

      self
    end

    private

    def extract_time(doc)
      date_img = doc.at_css('img[src*="ikt701da"]')
      time_img = doc.at_css('img[src*="ikt701ti"]')

      date_text = ocr_image(IMAGE_URL + date_img['src'],
                            lang: :jpn, crop: true).strip
      time_text = ocr_image(IMAGE_URL + time_img['src'],
                            lang: :jpn, crop: true).strip

      combined_text = date_text + time_text

      year, month, day, hour, minute = combined_text.scan(/[\d]+/).map(&:to_i)
      TZ.local_to_utc(Time.new(year, month, day, hour, minute))
    end

    def extract_power(doc)
      img = doc.at_css('img[src*="ikt721-1"]')

      text = ocr_image(IMAGE_URL + img['src'])
      values = text.scan(/\d+/).map(&:to_f)
      values[1] * 1000 if values.length >= 2
    end
  end
end
