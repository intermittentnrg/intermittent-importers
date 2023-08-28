class AlterGenerationUnits < ActiveRecord::Migration[5.2]
  def change
    rename_table :generation_units, :generation_unit
    change_table :units do |t|
      t.rename :code, :name
      t.remove_index :internal_id
      t.index :internal_id, unique: true
    end
  end
end
