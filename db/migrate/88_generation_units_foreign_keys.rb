class GenerationUnitsForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :generation_units, :units
    add_foreign_key :units, :areas
    add_foreign_key :units, :production_types
  end
end
