#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require 'date'
require 'active_support'
require 'active_support/core_ext'

require './lib/activerecord-connect'
require './app/models/generation'
require './app/models/area'

require './lib/elexon'
if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country]"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

area_id = Area.where(source: Elexon::Load.source_id, code: 'GB').pluck(:id).first

require 'httparty'
@report = 'B1620'
ELEXON_ENDPOINT = "https://api.bmreports.com/BMRS/#{@report}/v1"


(from...to).each do |time|
  e = Elexon::Generation.new(time)

  points = e.points
  points.each do |p|
    p[:area_id] = area_id
    p.delete :country
  end
  puts points
  #require 'pry' ; binding.pry
  Generation.upsert_all points
end
