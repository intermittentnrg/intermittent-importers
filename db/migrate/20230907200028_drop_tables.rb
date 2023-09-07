class DropTables < ActiveRecord::Migration[7.0]
  def change
    drop_table :generation_unit_old
    drop_table :svk_controlroom
    drop_table :svk_mimer_generation
  end
end
