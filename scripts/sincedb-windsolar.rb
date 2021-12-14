#!/usr/bin/env ruby
require 'bundler/setup'
require 'date'
require './lib/entsoe'

require 'semantic_logger'
SemanticLogger.default_level = :trace
SemanticLogger.add_appender(io: $stderr, formatter: :color)
logger = SemanticLogger['sincedb-windsolar.rb']

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

SOURCE = ENTSOE::WindSolar
OUT_SERIES = 'entsoe_windsolar'

require './lib/pump'
Pump.new(SOURCE, OUT_SERIES, influxdb).run
