#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date

areas = {}
time = from
loop do
  e = Nordpool::CapacityChart.new(time)

  points = e.points
  points.each do |p|
    p[:from_area_id] = areas[p[:from_area]] ||= Area.find_or_create_by(source: Nordpool::Capacity.source_id, code: p[:from_area]).id
    p[:to_area_id] = areas[p[:to_area]] ||= Area.find_or_create_by(source: Nordpool::Capacity.source_id, code: p[:to_area]).id
    p.delete :from_area
    p.delete :to_area
  end
  puts points
  #require 'pry' ; binding.pry
  Transmission.upsert_all points
  puts "break if #{time} > #{to}"
  break if time > to
  time += 7.days
end
