#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

require 'influxdb'
influxdb = InfluxDB::Client.new 'intermittency', host: ENV['INFLUX_HOST'], async: true

#
ENTSOE::DOMAIN_MAPPINGS.keys.select { |k| k.match /^DK/ }.each do |country|
  path = "data/generator/#{country}-2021.json"
  $stderr.puts path
  if File.exists?(path) && !File.zero?(path)
    $stderr.puts "skip"
    break
  end
  File.open(path, 'w') do |f|
    # e = ENTSOE.new country: country, from: '2021-01-01', to: '2021-09-24'
    #, document_type: 'A75', process_type: :realised
    e = ENTSOE::Generation.new country: country, from: '2021-08-01', to: '2021-09-26'
    e.points.each { |p| f.puts p.to_json }
  end
end
