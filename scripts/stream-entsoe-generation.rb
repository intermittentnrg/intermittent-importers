#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

require './lib/activerecord-connect'
require './app/models/entsoe_generation'
require './app/models/generation'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : ENTSOE::DOMAIN_MAPPINGS.keys).each do |country|
  puts country
  e = ENTSOE::Generation.new country: country, from: from, to: to
  puts e.points
  #require 'pry' ; binding.pry
  Generation.insert_all e.points.each { |p| p[:updated_at] = p[:created_at] }
rescue
  puts $!
  puts $!.backtrace
end
