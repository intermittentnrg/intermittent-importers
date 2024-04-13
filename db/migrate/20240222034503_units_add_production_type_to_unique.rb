class UnitsAddProductionTypeToUnique < ActiveRecord::Migration[7.0]
  def change
    change_table :units do |t|
      t.remove_index :internal_id
      t.index [:internal_id, :production_type_id], unique: true
    end
  end
end
