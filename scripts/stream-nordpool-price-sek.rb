#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
require './app/models/price'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

areas = {}
(from...to).each do |time|
  e = Nordpool::PriceSEK.new(time)

  points = e.points
  points.each do |p|
    area_id = areas[p[:country]] ||= Area.where(source: Nordpool::PriceSEK.source_id, code: p[:country]).pluck(:id).first
    p[:area_id] = area_id
    p.delete :country
  end
  puts points
  #require 'pry' ; binding.pry
  Price.upsert_all points
end
