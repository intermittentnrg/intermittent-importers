class GenerationUnitHiresCompressionAfter < ActiveRecord::Migration[7.0]
  def change
    execute "SELECT remove_compression_policy('generation_unit_hires')"
    execute "SELECT add_compression_policy('generation_unit_hires', compress_after => INTERVAL '3d');"
  end
end
