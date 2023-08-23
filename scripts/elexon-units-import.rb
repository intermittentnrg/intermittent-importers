#!/usr/bin/env ruby
require './lib/init'
require './lib/activerecord-connect'

#fuel_types
rows = FastestCSV.read("data/elexon/BMUFuelType.csv")
header = rows.shift

wind = rows.select {|row| row[2] == "WIND"}
wind_units = wind.map { |row| row[0] }

area = Area.find_by!(code: 'GB', source: 'elexon')
pt = ProductionType.find_by!(name: 'wind')

rows = FastestCSV.read("data/elexon/reg_bm_units.csv")
unit_to_name = Hash[rows.map { |row| [row[5], row[1]] }]
#require 'pry' ; binding.pry


wind_units.each do |unit_id|
  unit = Unit.find_or_create_by!(area: area, production_type: pt, internal_id: unit_id)
  unit.update! code: unit_to_name[unit_id]
  puts unit.inspect
  require 'pry' ; binding.pry
end
