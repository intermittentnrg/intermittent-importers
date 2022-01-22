class AddAreasCodeIndex < ActiveRecord::Migration[5.2]
  def change
    change_table :areas do |t|
      t.index :code
      t.index :entsoe_id, unique: true
    end
  end
end
