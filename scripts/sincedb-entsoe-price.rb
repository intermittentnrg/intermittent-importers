#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['sincedb-entsoe-price.rb']

Pump.new(ENTSOE::Price, Price).run
