class LoadCompression < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE load SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'area_id'
)
SQL
    execute "SELECT add_compression_policy('load', INTERVAL '1 year');"
  end
end
