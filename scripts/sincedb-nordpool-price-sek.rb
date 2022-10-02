#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Pump::Nordpool.new(Nordpool::PriceSEK, Price).run
