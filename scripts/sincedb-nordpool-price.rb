#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Pump::NordpoolPrice.new(Nordpool::Price, Price).run
