#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

areas = {}
(from...to).each do |time|
  e = Nordpool::Capacity.new(time)

  points = e.points
  points.each do |p|
    p[:from_area_id] = areas[p[:from_country]] ||= Area.find_or_create_by(source: Nordpool::Capacity.source_id, code: p[:from_country]).id
    p[:to_area_id] = areas[p[:to_country]] ||= Area.find_or_create_by(source: Nordpool::Capacity.source_id, code: p[:to_country]).id
    p.delete :from_country
    p.delete :to_country
  end
  puts points
  #require 'pry' ; binding.pry
  Transmission.upsert_all points
end
