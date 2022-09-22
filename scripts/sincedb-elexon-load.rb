#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['sincedb-generation.rb']

Pump.new(Elexon::Load, Load).run
