#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

EiaBulk::Demand.cli(ARGV)
