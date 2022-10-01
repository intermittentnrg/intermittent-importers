#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['sincedb-nordpool-capacity.rb']

Pump::NordpoolCapacity.new(Nordpool::Capacity, Transmission).run
