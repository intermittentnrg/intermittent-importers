#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-generation.rb']

if ARGV.length < 3
  $stderr.puts "#{$0} <from> <to> <country ...>"
  exit 1
end
from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date
#country = Area.find_by!(code: ARGV.shift, source: Entsoe::Unit.source_id)

ARGV.each do |area_code|
  area = Area.find_by!(code: area_code, source: Entsoe::Unit.source_id)
  (from..to).each do |date|
    SemanticLogger.tagged(country: area.code) do
      e = Entsoe::Unit.new(area, from: date, to: date+1.day)
      e.process
    rescue
      logger.error "Exception processing #{area_code}", $!
    end
  end
end
