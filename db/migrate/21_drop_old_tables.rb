class DropOldTables < ActiveRecord::Migration[5.2]
  disable_ddl_transaction!
  def change
    drop_table :entsoe_generation
    drop_table :elexon_generation
    drop_table :entsoe_load
    drop_table :elexon_load
  end
end
