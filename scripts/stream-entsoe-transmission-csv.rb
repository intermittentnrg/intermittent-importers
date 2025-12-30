#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

EntsoeCsv::Transmission.cli(ARGV)
