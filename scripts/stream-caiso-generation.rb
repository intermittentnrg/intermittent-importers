#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = Date.parse ARGV.shift
to = Date.parse ARGV.shift

areas = {}
production_types = {}
(from...to).each do |time|
  e = Caiso::Generation.new(time)

  points = e.points
  points.each do |p|
    area_id = areas[p[:country]] ||= Area.where(source: Caiso::Generation.source_id, code: p[:country]).pluck(:id).first
    p[:area_id] = area_id
    p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first)
    p.delete :production_type
    p.delete :country
  end
  puts points
  #require 'pry' ; binding.pry
  Generation.upsert_all points
end
