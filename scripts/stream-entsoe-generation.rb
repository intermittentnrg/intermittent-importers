#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

require './lib/activerecord-connect'
require './app/models/generation'
require './app/models/area'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : ENTSOE::DOMAIN_MAPPINGS.keys).each do |country|
  puts country
  area_id = Area.where(source: ENTSOE::Generation.source_id, code: country).pluck(:id).first
  e = ENTSOE::Generation.new country: country, from: from, to: to
  points = e.points
  puts points
  #require 'pry' ; binding.pry
  points.each do |p|
    p.delete :country
    p.delete :process_type
    p[:area_id] = area_id
    #p[:updated_at] = p[:created_at]
  end
  Generation.upsert_all points
rescue
  puts $!
  puts $!.backtrace
end
