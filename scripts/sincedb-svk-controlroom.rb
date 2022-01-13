#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-svk-mimer-generation.rb']

require './lib/entsoe'
require './lib/svk_controlroom'
require './lib/activerecord-connect'
require './app/models/svk_controlroom'

require './lib/pump'
Pump.new(SvkControlroomParser, SvkControlroom).run
