#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

require './lib/activerecord-connect'
require './app/models/entsoe_price'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : ENTSOE::COUNTRIES.keys).each do |country|
  puts country
  e = ENTSOE::Price.new country: country, from: from, to: to
  puts e.points
  #require 'pry' ; binding.pry
  EntsoePrice.insert_all e.points
rescue
  puts $!
  puts $!.backtrace
end
