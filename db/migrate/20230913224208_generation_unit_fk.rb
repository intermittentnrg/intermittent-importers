class GenerationUnitFk < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :generation_unit, :units
  end
end
