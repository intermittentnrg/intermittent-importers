class RebuildGenerationUnit < ActiveRecord::Migration[7.0]
  def change
    execute "CREATE TABLE generation_unit_tmp (LIKE generation_unit)"
    execute "ALTER TABLE generation_unit_tmp ALTER time TYPE timestamptz"
    execute <<-SQL
      SELECT create_hypertable('generation_unit_tmp', 'time',
        chunk_time_interval => INTERVAL '1 year');
    SQL
    execute "LOCK generation_unit IN EXCLUSIVE MODE"
    execute "INSERT INTO generation_unit_tmp SELECT * FROM generation_unit"
    execute "ALTER TABLE generation_unit RENAME TO generation_unit_old"
    execute "ALTER TABLE generation_unit_tmp RENAME TO generation_unit"
  end
end
