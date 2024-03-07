class UnitEnabled < ActiveRecord::Migration[7.0]
  def change
    change_table :units do |t|
      t.change :enabled, :boolean, null: false, default: true
    end
  end
end
