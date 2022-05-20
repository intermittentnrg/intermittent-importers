#!/usr/bin/env ruby
require 'bundler/setup'
require 'dotenv/load'

require './lib/elexon'
require './lib/activerecord-connect'
require './app/models/load'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-generation.rb']

require './lib/pump'
Pump.new(Elexon::Load, Load).run
