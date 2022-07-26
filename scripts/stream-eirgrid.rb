#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/eirgrid'

require './lib/activerecord-connect'
require './app/models/generation'
require './app/models/area'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

e = Eirgrid::Wind.new(from: Date.parse(from), to: Date.parse(to))
area_id = Area.where(source: 'eirgrid', code: 'IE').pluck(:id).first
points = e.points
puts points
points.each { |p| p[:area_id] = area_id }
Generation.upsert_all points

