#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

EntsoeSftp::UnitCapacity.each &:process

