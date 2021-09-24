#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true
INFLUX_SERIES = 'load'

raise if ARGV.length < 2
from = ARGV.shift
to = ARGV.shift
(ARGV.present? ? ARGV : ENTSOE::DOMAIN_MAPPINGS.keys).each do |country|
  puts country
  e = ENTSOE::Load.new country: country, from: from, to: to
  puts e.points
  data = e.points.map do |p|
    {
      series: 'entsoe_load',
      values: { value: p[:value] },
      tags:   { country: p[:country] },
      timestamp: p[:timestamp].to_i
    }
  end
  influxdb.write_points(data)
rescue
  puts $!
  puts $!.backtrace
end
