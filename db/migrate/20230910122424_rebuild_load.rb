class RebuildLoad < ActiveRecord::Migration[7.0]
  def change
    execute "CREATE TABLE load_tmp (LIKE load)"
    execute "ALTER TABLE load_tmp ALTER time TYPE timestamptz"
    execute <<-SQL
      SELECT create_hypertable('load_tmp', 'time',
        chunk_time_interval => INTERVAL '1 year');
    SQL
    execute "LOCK load IN EXCLUSIVE MODE"
    execute "INSERT INTO load_tmp SELECT * FROM load"
    execute "ALTER TABLE load RENAME TO load_old"
    execute "ALTER TABLE load_tmp RENAME TO load"
  end
end
