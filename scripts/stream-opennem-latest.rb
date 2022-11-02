#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

raise 'FIXME'
if ARGV.length != 0
  $stderr.puts "#{$0} [region ...]"
  exit 1
end
from = Date.parse ARGV.shift
to = Date.parse ARGV.shift

areas = {}
production_types = {}

(from...to).select {|d| d.day==1}.each do |time|
  countries = ARGV.present? ? ARGV : Area.where(source: Opennem::Latest.source_id).pluck(:code)
  countries.each do |country|
    SemanticLogger.tagged(country) do
      e = Opennem::GenerationMonth.new(country: country, date: time)

      points = e.points
      points.each do |p|
        area_id = areas[p[:country]] ||= Area.where(source: Opennem::Latest.source_id, code: p[:country]).pluck(:id).first
        p[:area_id] = area_id
        p[:production_type_id] = (production_types[p[:production_type]] ||= ProductionType.where(name: p[:production_type]).pluck(:id).first)
        raise p[:production_type] if p[:production_type_id].nil?
        p.delete :production_type
        p.delete :country
      end
      #puts points
      #require 'pry' ; binding.pry
      Generation.upsert_all points
    end
  end
end
