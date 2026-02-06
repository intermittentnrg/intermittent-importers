# frozen_string_literal: true

require 'faraday'
require 'nokogiri'
require 'rtesseract'
require 'tempfile'
require 'fileutils'

module JapanNuclear
  class Base
    include CliMixin2::SnapshotWithDownload
    TZ = TZInfo::Timezone.get('Asia/Tokyo')

    def initialize
      @r_gen = []
      @r_units = []
      @faraday = Faraday.new
    end

    def done!
      Out::Generation.run(@r_gen, nil, nil, self.class.source_id) if @r_gen.any?
      Out::Unit.run(@r_units, nil, nil, self.class.source_id) if @r_units.any?
    end

    def self.source_id
      self::SOURCE_ID
    end

    private

    def add_unit(unit_id:, value:, time:, country:)
      @r_units << {
        time: time,
        country: country,
        unit_id: unit_id,
        production_type: 'nuclear',
        value: value
      }
    end

    def add_generation(value:, time:, country:)
      @r_gen << {
        time: time,
        country: country,
        production_type: 'nuclear',
        value: value
      }
    end

    def ocr_image(img_url, lang: :jpn, crop: false)
      response = @faraday.get(img_url)
      image_data = response.body

      tempfile = Tempfile.new(['image', File.extname(img_url)])
      tempfile.binmode
      tempfile.write(image_data)
      tempfile.close

      if crop
        system("convert #{tempfile.path} -trim +repage #{tempfile.path}.enhanced.gif")
        File.unlink tempfile.path
        File.rename "#{tempfile.path}.enhanced.gif", tempfile.path
      end

      begin
        options = { lang: lang }
        RTesseract.new(tempfile.path, options).to_s
      ensure
        tempfile.unlink
      end
    end

    def save_image(image_data, img_url, source_id)
      data_dir = File.join(Dir.pwd, 'data', source_id)
      FileUtils.mkdir_p(data_dir)

      filename = "#{Time.now.strftime('%Y%m%d_%H%M%S')}_#{File.basename(URI.parse(img_url).path)}"
      filepath = File.join(data_dir, filename)
      File.open(filepath, 'wb') { |f| f.write(image_data) }
      puts "Saved image to #{filepath}"
    end
  end
end
