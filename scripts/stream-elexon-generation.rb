#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country]"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

area_id = Area.where(source: Elexon::Load.source_id, code: 'GB').pluck(:id).first
production_types = {}

require 'httparty'
@report = 'B1620'
ELEXON_ENDPOINT = "https://api.bmreports.com/BMRS/#{@report}/v1"


(from...to).each do |time|
  e = Elexon::Generation.new(time)

  points = e.points
  points.each do |p|
    p[:area_id] = area_id
    p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
    p.delete :country
  end
  puts points
  #require 'pry' ; binding.pry
  Generation.upsert_all points
end
