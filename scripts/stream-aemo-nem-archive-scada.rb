#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

AemoNemArchive::Scada.cli(ARGV)
