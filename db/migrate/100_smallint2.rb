class Smallint2 < ActiveRecord::Migration[5.2]
  def change
    change_table :generation_unit do |t|
      t.change :unit_id, :integer, null: false, limit: 2
      t.change :value, :integer, null: false
    end
  end
end
