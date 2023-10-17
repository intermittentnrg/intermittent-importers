class GenerationAreasProductionTypeId < ActiveRecord::Migration[7.0]
  def change
    change_table :generation do |t|
      #t.integer :areas_production_type_id, length: 2
      t.references :areas_production_types, type: :smallint
    end
# UPDATE generation g
# SET areas_production_type_id=(SELECT id FROM areas_production_types apt WHERE g.area_id=apt.area_id AND g.production_type_id=apt.production_type_id)
# WHERE areas_production_type_id IS NULL
  end
end
