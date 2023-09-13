class GenerationPrimaryKey2 < ActiveRecord::Migration[7.0]
  def change
    drop_table :generation_old
    execute "ALTER INDEX generation_pkey1 RENAME TO generation_pkey"
  end
end
