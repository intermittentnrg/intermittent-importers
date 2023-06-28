#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : ENTSOE::COUNTRIES.keys).each do |country|
  puts country
  area_id = Area.where(source: ENTSOE::Generation.source_id, code: country).pluck(:id).first
  e = ENTSOE::Price.new country: country, from: from, to: to
  e.process
rescue
  puts $!
  puts $!.backtrace
end
