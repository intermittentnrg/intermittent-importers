#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-generation.rb']

while file = ARGV.shift
  e = ENTSOE::UnitSFTP.new(file)
  e.process
end
