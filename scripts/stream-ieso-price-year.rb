#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 1
  $stderr.puts "#{$0} <year>"
  exit 1
end
year = Chronic.parse(ARGV.shift).to_date

e = Ieso::PriceYear.new(year)
e.process
