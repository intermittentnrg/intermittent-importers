#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Pump.new(Ieso::Generation, Generation).run
