#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 0
  $stderr.puts "#{$0}"
  exit 1
end

e = NationalGridEso::Demand.new
e.process
