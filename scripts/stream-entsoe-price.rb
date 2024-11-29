#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-generation.rb']

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = Chronic.parse(ARGV.shift)
to = Chronic.parse(ARGV.shift)

(ARGV.present? ? ARGV : Entsoe::COUNTRIES.keys).each do |country|
  SemanticLogger.tagged(country:) do
    area_id = Area.where(source: Entsoe::Generation.source_id, code: country).pluck(:id).first
    e = Entsoe::Price.new(country:, from:, to:)
    e.process_price
  rescue
    logger.error "Exception processing #{country}", $!
  end
end
