class UnitEnabled < ActiveRecord::Migration[7.0]
  def change
    change_table :units do |t|
      t.boolean :enabled, null: false, default: true
    end
  end
end
