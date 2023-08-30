#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 1
  $stderr.puts "#{$0} <date> [region ...]"
  exit 1
end
week = Chronic.parse(ARGV.shift).to_datetime

countries = ARGV.present? ? ARGV : Area.where(source: Opennem::Week.source_id).pluck(:code)
countries.each do |country|
  SemanticLogger.tagged(country: country) do
    e = Opennem::Week.new(country: country, date: week)
    e.process
  end
end
