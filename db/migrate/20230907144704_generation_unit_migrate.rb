class GenerationUnitMigrate < ActiveRecord::Migration[7.0]
  def change
    execute "LOCK generation_unit IN EXCLUSIVE MODE"
    execute "INSERT INTO generation_unit_tmp SELECT * FROM generation_unit"
    execute "ALTER TABLE generation_unit RENAME TO generation_unit_old"
    execute "ALTER TABLE generation_unit_tmp RENAME TO generation_unit"
  end
end
