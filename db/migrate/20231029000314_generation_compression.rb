class GenerationCompression < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE generation_data SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'areas_production_type_id'
)
SQL
    execute "SELECT add_compression_policy('generation_data', INTERVAL '1 year');"
  end
end
