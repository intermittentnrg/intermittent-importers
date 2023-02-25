#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-generation.rb']

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : ENTSOE::DOMAIN_MAPPINGS.keys).each do |country|
  puts country
  area_id = Area.where(source: ENTSOE::Generation.source_id, code: country).pluck(:id).first
  production_types = {}
  e = ENTSOE::Generation.new country: country, from: from, to: to
  points = e.points
  puts points
  #require 'pry' ; binding.pry
  points.each do |p|
    p[:area_id] = area_id
    p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first) if p[:production_type]
    p.delete :country
    p.delete :process_type
    p.delete :production_type
    #p[:updated_at] = p[:created_at]
  end

  #Generation.where(time: from..to).where(area_id: area_id)
  rows=Generation.where(time: from...to).where(area_id: area_id).order(:time, :production_type_id)
  rows=rows.map { |r| r=r.attributes ; r.delete("created_at") ; r.delete("updated_at") ; r.symbolize_keys }

  diff = points-rows
  if diff
    diff.each do |d|
      logger.warn "new or updated", event: {duration: Time.now-d[:time]}, generation: d
    end
  end
  #points-rows # NEW & UPDATED ROWS
  #rows-points # OLD BAD VALUES
  #require 'pry' ; binding.pry

  Generation.upsert_all points
rescue
  puts $!
  puts $!.backtrace
end
