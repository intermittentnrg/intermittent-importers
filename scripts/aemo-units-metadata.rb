#!/usr/bin/env ruby
# coding: utf-8
require './lib/init'
require './lib/activerecord-connect'

#url = "https://raw.githubusercontent.com/opennem/opennem/master/opennem/data/stations.json"
#response = Faraday.get(url)
json = FastJsonparser.load 'data/aemo/stations.json'
#require 'pry' ; binding.pry

json.each do |facility|
  facility[:facilities].each do |f2|
    unit = Unit.joins(:area).where('area.source': Aemo::Base.source_id).find_by(internal_id: f2[:code])
    if unit
      unit.name = "#{facility[:name]} #{f2[:code]}"
      production_type = Opennem::Base::FUEL_MAP[f2[:fueltech_id]]
      if ["hydro_pumped_storage","battery_charging"].include? production_type
        if production_type != unit.production_type
          raise "New #{production_type} unit, generation data should be inverted"
        end
      end
      unit.production_type = ProductionType.find_by! name: production_type
      unit.area = Area.find_by(code: f2[:network_region], source: Aemo::Base.source_id)
      puts unit.name if unit.changed?
      unit.save!
      #puts unit.inspect
    else
      #puts "No unit #{facility[:code]}"
    end
  end
end
