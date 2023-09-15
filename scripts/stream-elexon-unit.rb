#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['stream-elexon-unit.rb']

Elexon::Unit.cli(ARGV)
