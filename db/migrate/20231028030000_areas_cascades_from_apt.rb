class AreasCascadesFromApt < ActiveRecord::Migration[7.0]
  def change
    remove_foreign_key :areas_production_types, :areas
    add_foreign_key :areas_production_types, :areas, on_delete: :cascade
  end
end
