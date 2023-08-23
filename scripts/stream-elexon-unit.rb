#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-elexon-unit.rb']

if ARGV.length < 3
  $stderr.puts "#{$0} <from> <to> <unit>"
  exit 1
end
from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date

ARGV.each do |unit|
  SemanticLogger.tagged(country: 'GB', unit: unit) do
    (from...to).each do |time|
      e = Elexon::Unit.new(time, unit)
      e.process
    rescue ENTSOE::EmptyError
      logger.warn "EmptyError #{time}"
    end
  end
end
