class GenerationUnitCompression < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE generation_unit SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'unit_id'
)
SQL
    execute "SELECT add_compression_policy('generation_unit', INTERVAL '1 year');"
  end
end
