#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

require './lib/activerecord-connect'
require './app/models/transmission'
require './app/models/area'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> <area_from> <area_to>"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

from_area = ARGV.shift
to_area = ARGV.shift

begin
  from_area_id = Area.where(source: ENTSOE::Transmission.source_id, code: from_area).pluck(:id).first
  to_area_id = Area.where(source: ENTSOE::Transmission.source_id, code: to_area).pluck(:id).first
  e = ENTSOE::Transmission.new from_area: from_area, to_area: to_area, from: from, to: to
  points = e.points
  require 'pp'
  pp points
  points.each do |p|
    p[:from_area_id] = from_area_id
    p[:to_area_id] = to_area_id
    p.delete :from_area
    p.delete :to_area
  end
  #require 'pry' ; binding.pry
  Transmission.insert_all points
rescue
  puts $!
  puts $!.backtrace
end
