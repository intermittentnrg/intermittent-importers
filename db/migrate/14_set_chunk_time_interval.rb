class SetChunkTimeInterval < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
SELECT set_chunk_time_interval('entsoe_generation', INTERVAL '1 month');
SELECT set_chunk_time_interval('elexon_generation', INTERVAL '1 month');
SELECT set_chunk_time_interval('entsoe_load', INTERVAL '1 month');
SELECT set_chunk_time_interval('elexon_load', INTERVAL '1 month');
SQL
      end
    end
  end
end
