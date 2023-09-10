class RebuildTransmission < ActiveRecord::Migration[7.0]
  def change
    execute "CREATE TABLE transmission_tmp (LIKE transmission)"
    execute "ALTER TABLE transmission_tmp ALTER time TYPE timestamptz"
    execute <<-SQL
      SELECT create_hypertable('transmission_tmp', 'time',
        chunk_time_interval => INTERVAL '1 year');
    SQL
    execute "LOCK transmission IN EXCLUSIVE MODE"
    execute "INSERT INTO transmission_tmp SELECT * FROM transmission"
    execute "ALTER TABLE transmission RENAME TO transmission_old"
    execute "ALTER TABLE transmission_tmp RENAME TO transmission"
  end
end
