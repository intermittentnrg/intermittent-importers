class AreasProductionTypesFk < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :areas_production_types, :areas
    add_foreign_key :areas_production_types, :production_types
  end
end
