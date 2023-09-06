#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 1
  $stderr.puts "#{$0} <month>"
  exit 1
end
date = Chronic.parse(ARGV.shift).to_date

e = Ieso::GenerationMonth.new(date)
e.process
