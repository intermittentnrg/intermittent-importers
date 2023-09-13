class GenerationPrimaryKey3 < ActiveRecord::Migration[7.0]
  def change
    drop_table :generation_unit_old
    execute "ALTER INDEX generation_unit_pkey1 RENAME TO generation_unit_pkey"
  end
end
