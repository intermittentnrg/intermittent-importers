#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require './lib/entsoe'

#.select { |k| k.match /^DK/ }
ENTSOE::DOMAIN_MAPPINGS.keys.each do |country|
  [:intraday, :current, :dayahead].each do |process_type|
    path = "data/#{country}-#{process_type}-2021.json"
    $stderr.puts path
    if File.exists?(path) && !File.zero?(path)
      $stderr.puts "skip"
      break
    end
    File.open(path, 'w') do |f|
      # e = ENTSOE.new country: country, from: '2021-01-01', to: '2021-09-24'
      e = ENTSOE.new country: country, from: '2021-08-01', to: '2021-09-26', process_type: process_type
      e.points.each { |p| f.puts p.to_json }
    end
    break
  rescue
    $stderr.puts $!
  end
end
