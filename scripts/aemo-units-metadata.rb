#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

#url = "https://raw.githubusercontent.com/opennem/opennem/69844775f717b7e6e6bc66f6dbb6e9b263bdfa57/opennem/data/stations.json"
#response = Faraday.get(url)
#json = JSON.parse(response.body)
json = FastJsonparser.load 'data/aemo/stations.json'
require 'pry' ; binding.pry

json.each do |facility|
  facility[:facilities].each do |f2|
    unit = Unit.joins(:area).where('area.source': Aemo::Base.source_id).find_by(internal_id: f2[:code])
    unless unit
      puts "No unit #{facility[:code]}"
    else
      unit.name = facility[:name]
      unit.production_type = ProductionType.find_by! name: Opennem::Base::FUEL_MAP[f2[:fueltech_id]]
      unit.area = Area.find_by(code: f2[:network_region], source: Aemo::Base.source_id)
      unit.save!
      #puts unit.inspect
    end
  end
end
