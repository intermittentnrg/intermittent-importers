#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [region ...]"
  exit 1
end
from = Time.parse "#{ARGV.shift} +10:00"
to = Time.parse "#{ARGV.shift} +10:00"

(from...to).select {|d| d.day==1}.each do |time|
  countries = ARGV.present? ? ARGV : Area.where(source: Opennem::GenerationMonth.source_id).pluck(:code)
  countries.each do |country|
    SemanticLogger.tagged(country) do
      e = Opennem::GenerationMonth.new(country: country, date: time)
      e.process
    end
  end
end
