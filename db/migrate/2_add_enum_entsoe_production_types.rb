class AddEnumEntsoeProductionTypes < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      CREATE TYPE entsoe_production_types AS ENUM ('biomass','fossil_brown_coal/lignite','fossil_coal-derived_gas','fossil_gas','fossil_hard_coal','fossil_oil','fossil_oil_shale','fossil_peat','geothermal','hydro_pumped_storage','hydro_run-of-river_and_poundage','hydro_water_reservoir','marine','nuclear','other','other_renewable','solar','waste','wind_offshore','wind_onshore');
    SQL
    change_column :entsoe_generation, :production_type, 'entsoe_production_types USING production_type::entsoe_production_types'
  end

  def down
    #update_column :entsoe_generation, :production_type, :string
    execute <<-SQL
      DROP TYPE entsoe_production_types;
    SQL
  end
end
