#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = Chronic.parse(ARGV.shift)
to = Chronic.parse(ARGV.shift)

(from...to).each do |time|
  e = Ieso::Generation.new(time)
  e.process
end
