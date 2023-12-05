class AptSourceArea < ActiveRecord::Migration[7.0]
  def change
    remove_column :areas_production_types, :source
    add_column :areas_production_types, :source_area_id, :integer, limit: 2, null: true
    reversible do |dir|
      dir.up do
        execute "UPDATE areas_production_types SET source_area_id=area_id"
        change_column :areas_production_types, :source_area_id, :integer, limit: 2, null: false
      end
    end
  end
end
