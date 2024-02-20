class GenerationUnitHiresCompression < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE generation_unit_hires SET (
 timescaledb.compress,
 timescaledb.compress_segmentby = 'unit_id'
)
SQL
    execute "SELECT add_compression_policy('generation_unit_hires', INTERVAL '1 day');"
  end
end
