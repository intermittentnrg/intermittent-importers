#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

EntsoeCSV::TransmissionCSV.cli(ARGV)
