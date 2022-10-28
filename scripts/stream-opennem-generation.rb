#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <month> [country ...]"
  exit 1
end
time = DateTime.parse ARGV.shift
#to = DateTime.parse ARGV.shift

areas = {}
production_types = {}
#(from...to).each do |time|
ARGV.each do |country|
  e = Opennem::Generation.new(country: country, date: time)

  points = e.points
  require 'pry' ; binding.pry
  points.each do |p|
    area_id = areas[p[:country]] ||= Area.where(source: Opennem::Generation.source_id, code: p[:country]).pluck(:id).first
    p[:area_id] = area_id
    p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first)
    p.delete :country
  end
  puts points
  Generation.upsert_all points
end
