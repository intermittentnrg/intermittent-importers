class AreasAreas < ActiveRecord::Migration[7.1]
  def change
    create_table :areas_areas, id: :smallserial do |t|
      t.integer :from_area_id, limit: 2, null: false
      t.integer :to_area_id, limit: 2, null: false
      t.index [:from_area_id, :to_area_id], unique: true
    end
    change_table :transmission do |t|
      t.references :areas_area, type: :smallint
    end
# INSERT INTO areas_areas (from_area_id,to_area_id)
# SELECT DISTINCT from_area_id,to_area_id FROM transmission WHERE areas_area_id IS NULL
# ON CONFLICT (from_area_id,to_area_id) DO NOTHING
  end
end
