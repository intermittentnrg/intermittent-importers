#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 1
  $stderr.puts "#{$0} <date> [region ...]"
  exit 1
end
year = Date.parse "#{ARGV.shift} +10:00"

countries = ARGV.present? ? ARGV : Area.where(source: Opennem::Week.source_id).pluck(:code)
countries.each do |country|
  SemanticLogger.tagged(country: country) do
    e = Opennem::Week.new(country: country, date: year)
    e.process
  end
end
