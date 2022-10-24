#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

areas = {}
e = Eia::Load.new from: from, to: to

points = e.points
points.each do |p|
  area_id = areas[p[:country]] ||= Area.find_or_create_by(source: Eia::Generation.source_id, code: p[:country], region: 'north_america').id
  p[:area_id] = area_id
  p.delete :country
end
puts points
#require 'pry' ; binding.pry

Load.upsert_all points
