#!/usr/bin/env ruby
require 'bundler/setup'

require './lib/entsoe'
require './lib/activerecord-connect'
require './app/models/generation'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-generation.rb']
#ActiveRecord::Base.logger = Logger.new(STDOUT)

require './lib/pump'
Pump.new(ENTSOE::Generation, Generation).run
