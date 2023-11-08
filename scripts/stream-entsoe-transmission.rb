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
  e = Entsoe::Transmission.new from_area: from_area, to_area: to_area, from: from, to: to
  e.process
rescue
  puts $!
  puts $!.backtrace
end
