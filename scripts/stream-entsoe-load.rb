#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-load.rb']

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : ENTSOE::DOMAIN_MAPPINGS.keys).each do |country|
  logger.info country
  area_id = Area.where(source: ENTSOE::Generation.source_id, code: country).pluck(:id).first
  e = ENTSOE::Load.new country: country, from: from, to: to
  points = e.points
  points.each do |p|
    p[:area_id] = area_id
    p.delete :country
  end
  #require 'pry' ; binding.pry
  logger.info "#{points.length} points"
  Load.upsert_all points
rescue
  puts $!
  puts $!.backtrace
end
