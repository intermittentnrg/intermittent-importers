#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

require './lib/activerecord-connect'
require './app/models/price'
require './app/models/area'

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
  points = e.points
  points.each do |p|
    p[:area_id] = area_id
    p.delete :country
  end
  #require 'pry' ; binding.pry
  puts points
  Price.upsert_all points
rescue
  puts $!
  puts $!.backtrace
end
