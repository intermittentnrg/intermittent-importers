class GenerationCapacityApt < ActiveRecord::Migration[7.0]
  def change
    change_table :generation_capacities do |t|
      t.integer :areas_production_type_id, length: 2
    end
      execute <<-SQL
UPDATE generation_capacities g
SET areas_production_type_id=(SELECT id FROM areas_production_types apt WHERE g.area_id=apt.area_id AND g.production_type_id=apt.production_type_id)
WHERE areas_production_type_id IS NULL
SQL
  end
end
