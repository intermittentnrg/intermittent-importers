# frozen_string_literal: true

require 'nokogiri'

class Enec
  include SemanticLogger::Loggable
  include AwsSqs

  MAX_RUNTIME = 15.minutes.to_i
  QUEUE_URL = ENV['ENEC_QUEUE_URL']
  QUEUE_REGION = 'me-central-1'

  TZ = TZInfo::Timezone.get('Asia/Dubai')

  def self.source_id
    'enec'
  end

  def self.cli(args)
    if args.empty?
      refresh
    else
      args.each { |file| new.add_file(file).done! }
    end
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

  def add_file(path)
    add_buffer(File.read(path))
  end

  def add_buffer(body)
    doc = Nokogiri::HTML(body)
    time = parse_time(doc)

    raise 'Could not parse time from HTML' unless time

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
