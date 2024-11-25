#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-entsoe-load.rb']

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = Chronic.parse(ARGV.shift)
to = Chronic.parse(ARGV.shift)

(ARGV.present? ? ARGV : Entsoe::DOMAIN_MAPPINGS.keys).each do |country|
  SemanticLogger.tagged(country:) do
    e = Entsoe::Load.new(country:, from:, to:)
    e.process
  end
rescue
  logger.error "Exception processing #{country}", $!
end
