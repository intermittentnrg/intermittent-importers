#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Pump.new(Eia::Load, Load).run
