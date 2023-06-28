#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

areas = {}
(from...to).each do |time|
  e = Nordpool::Transmission.new(time)
  e.process
end
