class IndexGenerationUnits < ActiveRecord::Migration[5.1]
  def change
    change_table :generation_units do |t|
      t.index :unit_id
      t.index :time
    end
    change_table :units do |t|
      t.index :area_id
      t.index :production_type_id
      t.index :internal_id
    end
  end
end
