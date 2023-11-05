class TransmissionCompression < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE transmission SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'from_area_id, to_area_id'
)
SQL
    execute "SELECT add_compression_policy('transmission', INTERVAL '1 year');"
  end
end
