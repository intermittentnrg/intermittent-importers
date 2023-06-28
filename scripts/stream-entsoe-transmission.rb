#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> <area_from> <area_to>"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

from_area = ARGV.shift
to_area = ARGV.shift

begin
  from_area_id = Area.where(source: ENTSOE::Transmission.source_id, code: from_area).pluck(:id).first
  to_area_id = Area.where(source: ENTSOE::Transmission.source_id, code: to_area).pluck(:id).first
  e = ENTSOE::Transmission.new from_area: from_area, to_area: to_area, from: from, to: to
  e.process
rescue
  puts $!
  puts $!.backtrace
end
