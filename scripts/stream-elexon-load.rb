#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require 'date'
require 'active_support'
require 'active_support/core_ext'

require './lib/activerecord-connect'
require './app/models/load'
require './app/models/area'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

area_id = Area.where(source: Elexon::Load.source_id, code: 'GB').pluck(:id).first

(from...to).each do |time|
  e = Elexon::Load.new(time)

  points = e.points
  points.each do |p|
    p[:area_id] = area_id
    p.delete :country
  end
  puts points
  #require 'pry' ; binding.pry
  Load.upsert_all points
end
