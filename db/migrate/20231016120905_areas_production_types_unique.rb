class AreasProductionTypesUnique < ActiveRecord::Migration[7.0]
  def change
    add_index :areas_production_types, [:area_id, :production_type_id], unique: true
  end
end
