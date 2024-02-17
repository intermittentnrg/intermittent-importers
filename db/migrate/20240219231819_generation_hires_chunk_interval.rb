class GenerationHiresChunkInterval < ActiveRecord::Migration[7.0]
  def change
    execute "SELECT set_chunk_time_interval('generation_hires_data', INTERVAL '24 hours')"
  end
end
