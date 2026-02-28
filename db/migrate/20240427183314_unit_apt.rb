class UnitApt < ActiveRecord::Migration[7.0]
  def change
    change_table :units do |t|
      t.belongs_to :areas_production_type, type: :smallint, foreign_key: true
    end
    execute "UPDATE units u SET areas_production_type_id=(SELECT id FROM areas_production_types u2 WHERE u.area_id=u2.area_id AND u.production_type_id=u2.production_type_id)"
  end
end
