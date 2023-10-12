class AreasProductionTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :areas_production_types, id: :smallserial do |t|
      t.integer :area_id, limit: 2, null: false
      t.integer :production_type_id, limit: 2, null: false
    end
#INSERT INTO areas_production_types (area_id,production_type_id)
#SELECT DISTINCT area_id,production_type_id FROM generation
  end
end
