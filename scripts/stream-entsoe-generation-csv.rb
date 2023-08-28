#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger[$0]

if ARGV.empty?
  $stderr.puts "#{$0} [file]"
  exit 1
end

ARGV.each do |file|
  e = ENTSOE::GenerationCSV.new(file)
  e.process
end
