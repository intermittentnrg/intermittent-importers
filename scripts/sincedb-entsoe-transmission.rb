#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['sincedb-entsoe-transmission.rb']

Pump::Process.new(ENTSOE::Transmission, Transmission).run
