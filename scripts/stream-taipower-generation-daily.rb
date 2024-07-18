#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Taipower::GenerationDaily.cli(ARGV)
