#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 2
  $stderr.puts "#{$0} <from> <to>"
  exit 1
end
from = DateTime.parse "#{ARGV.shift} UTC"
to = DateTime.parse "#{ARGV.shift} UTC"

(from...to).each do |time|
  e = Elexon::WindSolar.new(time)
  e.process
end
