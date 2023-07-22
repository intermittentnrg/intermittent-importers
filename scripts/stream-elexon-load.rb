#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-load.rb']

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date

(from...to).each do |time|
  e = Elexon::Load.new(time)
  e.process
end
