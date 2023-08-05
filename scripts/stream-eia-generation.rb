#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date

areas = {}
production_types = {}
countries = ARGV.present? ? ARGV : Area.where(source: Eia::Generation.source_id).pluck(:internal_id)
(from...to).each do |time|
  countries.each do |country|
    SemanticLogger.tagged(country) do
      e = Eia::Generation.new(from: time, to: time + 1.day, country: country)
      e.process
    end
  end
end
