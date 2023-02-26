#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 1
  $stderr.puts "#{$0} <month>"
  exit 1
end
time = DateTime.parse ARGV.shift
#to = DateTime.parse ARGV.shift

e = Ieso::GenerationMonth.new(time)
e.process
