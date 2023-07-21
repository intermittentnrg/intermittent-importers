#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = Chronic.parse(ARGV.shift)
to = Chronic.parse(ARGV.shift)

(ARGV.present? ? ARGV : ENTSOE::COUNTRIES.keys).each do |country|
  SemanticLogger.tagged(country:) do
    area_id = Area.where(source: ENTSOE::Generation.source_id, code: country).pluck(:id).first
    e = ENTSOE::Price.new(country:, from:, to:)
    e.process
  end
rescue
  puts $!
  puts $!.backtrace
end
