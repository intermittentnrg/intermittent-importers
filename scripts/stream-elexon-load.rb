#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Elexon::Load.cli(ARGV)
