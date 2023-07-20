#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-generation.rb']

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = Chronic.parse(ARGV.shift)
to = Chronic.parse(ARGV.shift)

(ARGV.present? ? ARGV : ENTSOE::COUNTRIES.keys).each do |country|
  SemanticLogger.tagged(country: country) do
    e = ENTSOE::Generation.new(country: country, from: from, to: to)
    e.process
  rescue
    logger.error "Exception processing #{country}", $!
  end
end
