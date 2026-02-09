class CreateUnitNamesAndUnitProductionTypes < ActiveRecord::Migration[7.1]
  def change
    create_table :unit_names do |t|
      t.references :unit, null: false, foreign_key: true
      t.string :name, limit: 100, null: false
      t.timestamps
      t.index %i[unit_id name], unique: true
    end

    create_table :unit_production_types do |t|
      t.references :unit, null: false, foreign_key: true
      t.references :production_type, null: false, foreign_key: true
      t.timestamps
      t.index %i[unit_id production_type_id], unique: true
    end
  end
end
