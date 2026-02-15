#!/usr/bin/env ruby
# Extract all DUIDs and fuel types from Excel file
# This script parses the NEM Generation Information Excel file
# to extract all units with their fuel types

require_relative "../config/application"
Rails.application.require_environment!
require 'roo'

# Excel file path
excel_file = 'data/aemo/NEM Generation Information Oct 2025.xlsx'

# Open the Excel file
workbook = Roo::Excelx.new(excel_file)
sheet = workbook.sheet('ExistingGeneration&NewDevs')

TECH_MAP = {
  "Solar PV - Fixed" => "solar_utility",
  "Reciprocating Engine - Compression ignition" => "fossil_oil_distillate",
  "Wind Turbine - Onshore" => "wind",
  "Solar PV - Single axis tracking" => "solar_utility",
  "Turbine - OCGT" => "fossil_gas_ocgt",
  "Reciprocating Engine - Spark ignition" => "fossil_gas_coal_mine_waste",
  "Hydro - Run of River" => "hydro",
  "Hydro - Dam" => "hydro",
  "Turbine - Steam Sub Critical" => "fossil_brown_coal/lignite",
  "Turbine - Steam Super Critical" => "fossil_hard_coal",
  "Turbine - CCGT" => "fossil_gas_ccgt",
  "Storage - Battery" => "battery",
  "Other - Other" => "biomass",
  "Storage - Pumped hydro" => "hydro"
}

# Extract data
# Column 7: DUID
# Column 5: Tech Type
# Column 3: Site Name
# Column 1: Region
data = []
duids = Set.new
(2..sheet.last_row).each do |row_num|
  duid = sheet.cell(row_num, 7).to_s.strip
  tech_type = sheet.cell(row_num, 5).to_s.strip
  fuel_type = sheet.cell(row_num, 6).to_s.strip
  site_name = sheet.cell(row_num, 3).to_s.strip
  region = sheet.cell(row_num, 1).to_s.strip
  production_type = TECH_MAP[tech_type]
  unit_name = "#{site_name} #{duid}"

  next if duid.empty?
  next if duids.include? duid
  duids << duid

  # puts [duid,fuel_type,site_name,region].join("\t")

  unit = Unit.joins(:area).where('area.source': Aemo::Base.source_id).find_by(internal_id: duid)
  unless unit
    puts "NOT IN DB:\t#{duid}"
    next
  else
    puts duid
  end

  if unit.name != unit_name
    puts "\t#{unit.name}\t#{unit_name}"
    unit.name = unit_name
  end

  if unit.area.code != region
    area = Area.find_by(source: 'aemo', internal_id: region)
    puts "\t#{unit.area.code}\t#{area.code}"
    unit.area = area
  end

  if unit.production_type.name != production_type
    if ["hydro_pumped_storage","battery_charging"].include? production_type
      logger.error "New #{production_type} unit #{duid} #{site_name}, old #{unit.production_type.name}, generation data needs to be inverted"
    end
    puts "\t#{unit.production_type.name}\t#{production_type}"
    pt = ProductionType.find_by!(name: production_type)
    unit.production_type = pt
  end

  unit.save!
end
