#!/usr/bin/env ruby
require 'bundler/setup'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-load.rb']

require './lib/entsoe'
require './lib/activerecord-connect'
require './app/models/load'

require './lib/pump'
Pump.new(ENTSOE::Load, Load).run
