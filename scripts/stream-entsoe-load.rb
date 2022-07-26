#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['stream-load.rb']

require './lib/entsoe'

require './lib/activerecord-connect'
require './app/models/load'
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
  e = ENTSOE::Load.new country: country, from: from, to: to
  points = e.points
  points.each do |p|
    p[:area_id] = area_id
    p.delete :country
  end
  #require 'pry' ; binding.pry
  puts points
  Load.upsert_all points
rescue
  puts $!
  puts $!.backtrace
end
