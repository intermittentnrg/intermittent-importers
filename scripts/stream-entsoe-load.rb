#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['stream-load.rb']

require './lib/entsoe'

require './lib/activerecord-connect'
require './app/models/entsoe_load'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : ENTSOE::DOMAIN_MAPPINGS.keys).each do |country|
  puts country
  e = ENTSOE::Load.new country: country, from: from, to: to
  puts e.points
  #require 'pry' ; binding.pry
  EntsoeLoad.insert_all e.points
rescue
  puts $!
  puts $!.backtrace
end
