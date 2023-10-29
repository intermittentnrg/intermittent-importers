class PricesCompression < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE prices SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'area_id'
)
SQL
    execute "SELECT add_compression_policy('prices', INTERVAL '1 year');"
  end
end
