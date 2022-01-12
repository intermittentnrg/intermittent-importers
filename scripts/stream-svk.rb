#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/svk'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true
INFLUX_SERIES = 'svk_generation'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country ...]"
  exit 1
end
from = ARGV.shift
to = ARGV.shift

(ARGV.present? ? ARGV : Svk::COUNTRIES.keys).each do |country|
  Svk::PRODUCTION_TYPES.keys.each do |production|
    puts "#{country}/#{production}"
    e = Svk::Generation.new area: country, production: production, from: from, to: to
    puts e.points
    data = e.points.map do |p|
      {
        series: INFLUX_SERIES,
        values: { value: p[:value] },
        tags:   { country: p[:country], production_type: p[:production_type], process_type: p[:process_type] },
        timestamp: p[:timestamp].to_i
      }
    end
    influxdb.write_points(data)
  rescue
    puts $!
    puts $!.backtrace
  end
end
