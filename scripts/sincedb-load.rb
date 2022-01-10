#!/usr/bin/env ruby
require 'bundler/setup'

require './lib/entsoe'
require './lib/activerecord-connect'
require './app/models/entsoe_load'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-load.rb']

require './lib/pump'
Pump.new(ENTSOE::Load, EntsoeLoad).run
