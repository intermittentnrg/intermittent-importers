#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['sincedb-nordpool-transmission.rb']

Pump::NordpoolTransmission.new(Nordpool::Transmission, Transmission).run
