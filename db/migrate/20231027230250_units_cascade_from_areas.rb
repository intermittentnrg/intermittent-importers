class UnitsCascadeFromAreas < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :units, :areas
    add_foreign_key :units, :areas, on_delete: :cascade
  end
end
