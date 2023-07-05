#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

if ARGV.length != 0
  $stderr.puts "Usage: #{$0}"
  exit 1
end

e = Opennem::Latest.new
e.process
