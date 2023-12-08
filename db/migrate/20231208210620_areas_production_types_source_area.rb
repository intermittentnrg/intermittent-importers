class AreasProductionTypesSourceArea < ActiveRecord::Migration[7.0]
  def change
    change_table :areas_production_types do |t|
      t.remove_index name: 'index_areas_production_types_on_area_id_and_production_type_id'
      t.index [:area_id, :production_type_id], name: 'index_apt_on_area_id_and_production_type_id'
      t.index [:source_area_id, :production_type_id], unique: true, name: 'index_apt_on_source_area_id_and_production_type_id'
    end
  end
end
