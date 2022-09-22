#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['sincedb-entsoe-load.rb']

Pump.new(ENTSOE::Load, Load).run
