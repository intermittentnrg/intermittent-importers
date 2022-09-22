#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'
logger = SemanticLogger['sincedb-generation.rb']
#ActiveRecord::Base.logger = Logger.new(STDOUT)

Pump.new(ENTSOE::Generation, Generation).run
