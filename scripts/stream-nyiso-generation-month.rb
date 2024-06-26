#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 1
  $stderr.puts "#{$0} <month>"
  exit 1
end
time = DateTime.parse ARGV.shift
#to = DateTime.parse ARGV.shift

areas = {}
production_types = {}
#(from...to).each do |time|
  e = Nyiso::GenerationMonth.new(time)

  points = e.points
  points.each do |p|
    area_id = areas[p[:country]] ||= Area.where(source: Nyiso::GenerationMonth.source_id, code: p[:country]).pluck(:id).first
    p[:area_id] = area_id
    p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first)
    p.delete :country
  end
  puts points
  #require 'pry' ; binding.pry
  Generation.upsert_all points
#end
