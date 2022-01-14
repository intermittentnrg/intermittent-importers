#!/usr/bin/env ruby
# coding: utf-8
require 'bundler/setup'
require 'dotenv/load'

require 'date'
require 'active_support'
require 'active_support/core_ext'

require './lib/activerecord-connect'
require './app/models/elexon_load'

if ARGV.length < 2
  $stderr.puts "#{$0} <from> <to> [country]"
  exit 1
end
from = DateTime.parse ARGV.shift
to = DateTime.parse ARGV.shift

require 'httparty'
@report = 'B0610'
ELEXON_ENDPOINT = "https://api.bmreports.com/BMRS/#{@report}/v1"

(from...to).each do |time|
  @options = {}
  @options[:ServiceType] = 'xml'
  @options[:APIKey] = ENV['ELEXON_TOKEN']
  @options[:Period] = '*'
  @options[:SettlementDate] = time.strftime('%Y-%m-%d')
  res = HTTParty.get(
    ELEXON_ENDPOINT,
    query: @options,
    debug_output: $stdout
  )

  r = []
  res.parsed_response['response']['responseBody']['responseList']['item'].each do |item|
    r << {
      time: DateTime.strptime(item['settlementDate'], '%Y-%m-%d') + (item['settlementPeriod'].to_i * 30).minutes,
      value: item['quantity'].to_i
    }
  end
  puts r
  ElexonLoad.insert_all r
end
