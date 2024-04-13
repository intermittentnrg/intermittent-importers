class LoadAreaIdSmallint < ActiveRecord::Migration[7.0]
  def change
    execute "SELECT remove_compression_policy('load')"
    execute "SELECT decompress_chunk(c, true) FROM show_chunks('load') c"
    execute "ALTER TABLE load SET (timescaledb.compress=false)"
    change_table :load do |t|
      t.change :area_id, :integer, null: false, limit: 2
    end
    execute <<-SQL
ALTER TABLE load SET (
  timescaledb.compress,
  timescaledb.compress_segmentby = 'area_id'
)
SQL
    execute "SELECT add_compression_policy('load', INTERVAL '1 year');"
  end
end
