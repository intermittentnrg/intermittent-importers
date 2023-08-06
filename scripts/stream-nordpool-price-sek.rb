#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
require './app/models/price'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date

areas = {}
(from...to).each do |time|
  e = Nordpool::PriceSEK.new(time)
  e.process
end
