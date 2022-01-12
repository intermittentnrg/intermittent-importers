#!/usr/bin/env ruby
require 'bundler/setup'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-svk-mimer-generation.rb']

require './lib/entsoe'
require './lib/svk'
require './lib/activerecord-connect'
require './app/models/svk_mimer_generation'

require './lib/pump'
Pump.new(Svk::Generation, SvkMimerGeneration).run
