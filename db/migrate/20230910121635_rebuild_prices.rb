class RebuildPrices < ActiveRecord::Migration[7.0]
  def change
    execute "CREATE TABLE prices_tmp (LIKE prices)"
    execute "ALTER TABLE prices_tmp ALTER time TYPE timestamptz"
    execute <<-SQL
      SELECT create_hypertable('prices_tmp', 'time',
        chunk_time_interval => INTERVAL '1 year');
    SQL
    execute "LOCK prices IN EXCLUSIVE MODE"
    execute "INSERT INTO prices_tmp SELECT * FROM prices"
    execute "ALTER TABLE prices RENAME TO prices_old"
    execute "ALTER TABLE prices_tmp RENAME TO prices"
  end
end
