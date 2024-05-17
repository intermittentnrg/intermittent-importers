#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
require 'chronic'

unless ARGV.length==3
  $stderr.puts "#${0} <from> <to> <where>"
  abort
end

from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date
where = ARGV.shift

#GenerationUnit.chunks.where(range_end: from.., range_start: ..to).order(:range_start).each do |chunk|
#  puts "#{[from,chunk.range_start].max} #{[to,chunk.range_end].min}"
(from..to).each do |date|
  #date=date.to_time
  GenerationUnit.aggregate_to_generation(date, date+1.day, where)
end
