#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = Date.parse ARGV.shift
to = Date.parse ARGV.shift

areas = {}
production_types = {}
(from...to).each do |time|
  e = Caiso::Generation.new(time)
  e.process
end
