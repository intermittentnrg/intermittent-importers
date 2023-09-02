#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end

from = Chronic.parse(ARGV.shift).to_date
to = Chronic.parse(ARGV.shift).to_date

(from...to).select {|d| d.day==1}.each do |date|
  Aemo::ScadaMMS.new(date).process
end
