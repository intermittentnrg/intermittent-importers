#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Pump::Process.new(ENTSOE::Transmission, Transmission).run
