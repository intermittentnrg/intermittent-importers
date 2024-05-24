#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'
require 'fast_jsonparser'

#url = "https://raw.githubusercontent.com/opennem/opennem/master/opennem/data/stations.json"
#response = Faraday.get(url)
json = FastJsonparser.load 'data/aemo/stations.json'
#require 'pry' ; binding.pry
logger = SemanticLogger[$0]

json.each do |facility|
  next unless facility[:facilities].first[:interconnector]
  from_area = facility[:facilities].first[:interconnector_region_from]
  to_area = facility[:facilities].first[:interconnector_region_to]
  #puts %Q(  '#{facility[:code]}' => {from_area: '#{from_area}', to_area: '#{to_area}'})
  puts %Q(  '#{facility[:code]}' => ['#{from_area}', '#{to_area}'],)
end
