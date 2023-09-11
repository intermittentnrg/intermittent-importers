class RebuildGeneration < ActiveRecord::Migration[7.0]
  def change
    execute "CREATE TABLE generation_tmp (LIKE generation)"
    execute "ALTER TABLE generation_tmp ALTER time TYPE timestamptz"
    execute <<-SQL
      SELECT create_hypertable('generation_tmp', 'time',
        chunk_time_interval => INTERVAL '1 year');
    SQL
    execute "LOCK generation IN EXCLUSIVE MODE"
    execute "INSERT INTO generation_tmp SELECT * FROM generation"
    execute "ALTER TABLE generation RENAME TO generation_old"
    execute "ALTER TABLE generation_tmp RENAME TO generation"
  end
end
