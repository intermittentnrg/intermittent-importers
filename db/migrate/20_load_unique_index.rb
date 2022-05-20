class LoadUniqueIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :load, [:time], unique: true
    add_index :load, [:time, :area_id], unique: true
  end
end
