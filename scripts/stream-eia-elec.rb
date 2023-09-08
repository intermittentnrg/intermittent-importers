#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 1
  $stderr.puts "#{$0}: <file>"
end

EiaBulk::ELEC.new(ARGV.shift).process
