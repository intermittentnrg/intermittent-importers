#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Pump::EiaGeneration.new(Eia::Generation, Generation).run
