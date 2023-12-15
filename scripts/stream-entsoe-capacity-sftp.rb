#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

EntsoeSftp::Capacity.each &:process
