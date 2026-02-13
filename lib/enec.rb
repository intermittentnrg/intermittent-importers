# frozen_string_literal: true

require 'faraday'
require 'nokogiri'

class Enec
  include SemanticLogger::Loggable
  include CliMixin2::SnapshotWithDownload

  TZ = TZInfo::Timezone.get('Asia/Dubai')
  URL = 'https://www.enec.gov.ae/'

  def self.source_id
    'enec'
  end

  def initialize
    @r_unit = []
    @r_gen = []
  end

  def unit_id(unit_num)
    Unit.joins(:area).where(internal_id: "BARAKAH-#{unit_num}",
                            area: { source: self.class.source_id }).pluck(:id).first
  end

  def apt_id
    AreasProductionType.joins(:area, :production_type).where(
      area: { source: self.class.source_id },
      production_type: { name: 'nuclear' }
    ).pluck(:id).first
  end

  def add(save_zip = false)
    res = Faraday.new do |f|
      f.response :raise_error
    end.get(URL)
    last_modified = res.headers['Last-Modified']&.then { |h| Time.httpdate(h) }
    save_html(res.body, last_modified) if save_zip
    add_buffer(res.body, last_modified)
  end

  def add_file(path)
    add_buffer(File.read(path), nil)
  end

  def save_html(body, time)
    filename = time.strftime('%Y%m%d_%H%M%S.html')
    path = "data/enec/#{filename}"
    FileUtils.mkdir_p('data/enec')
    File.binwrite(path, body)
    logger.info "Saved #{path}"
  end

  def add_buffer(body, last_modified = nil)
    doc = Nokogiri::HTML(body)
    time = parse_time(doc) || last_modified

    (1..4).each do |unit_num|
      gwh_elem = doc.at_css("#count-air-unit#{unit_num}")
      next unless gwh_elem

      value = gwh_elem.at_css('.count-number')&.text&.strip || gwh_elem.text.strip
      value = (value.to_f * 1_000_000).to_i
      @r_unit << {
        time:,
        unit_id: unit_id(unit_num),
        value:
      }
    end

    global_elem = doc.at_css('#count-air-unit-globlal')
    if global_elem
      value = global_elem.at_css('.count-number')&.text&.strip || global_elem.text.strip
      value = (value.to_f * 1_000_000).to_i
      @r_gen << {
        time:,
        areas_production_type_id: apt_id,
        value:
      }
    end

    self
  end

  def parse_time(doc)
    script = doc.at_css('script:contains("actualDate")')&.text
    if script && script =~ /let actualDate = new Date\("([^"]+)"\)/
      return Time.strptime(::Regexp.last_match(1),
                           '%Y-%m-%d %H:%M:%S')
    end

    logger.warn 'Could not parse time from HTML'
    false
  end

  def done!
    GenerationUnitCounter.upsert_all(@r_unit, unique_by: %i[unit_id time])
    GenerationCounter.upsert_all(@r_gen, unique_by: %i[areas_production_type_id time])
    logger.info "done! #{@r_unit.length} unit records, #{@r_gen.length} aggregate records"
  end
end
