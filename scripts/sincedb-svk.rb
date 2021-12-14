#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/svk'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true
OUT_SERIES = 'svk_generation'

influxdb.query("SELECT time,country,production_type,LAST(value) FROM #{OUT_SERIES} WHERE time > '2021-06-01' GROUP BY country,production_type").each do |row|
  country    = row['tags']['country']
  production = row['tags']['production_type']
  from       = DateTime.parse(row['values'][0]['time']).strftime('%Y-%m-%d')
  to         = DateTime.now.strftime('%Y-%m-%d')
  puts "#{country}/#{production}"

  e = Svk::Generation.new area: country, production: production, from: from, to: to
  puts e.points
  data = e.points.map do |p|
    {
      series: OUT_SERIES,
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
