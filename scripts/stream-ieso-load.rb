#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 1
  $stderr.puts "#{$0} <year>"
  exit 1
end
year = DateTime.parse ARGV.shift

e = Ieso::Load.new year
area_id = Area.find_or_create_by(source: Ieso::Load.source_id, code: 'CA-ON', region: 'north_america').id

points = e.points
points.each do |p|
  p[:area_id] = area_id
  p.delete :country
end
puts points
#require 'pry' ; binding.pry

Load.upsert_all(points) if points.present?
