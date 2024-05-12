#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

Cammesa::ProgramacionDiaria.cli(ARGV)
