class GenerationUnitHypertableTmp < ActiveRecord::Migration[5.2]
  def change
    execute "CREATE TABLE generation_unit_tmp (LIKE generation_unit)"
    execute <<-SQL
      SELECT create_hypertable('generation_unit_tmp', 'time',
        chunk_time_interval => INTERVAL '1 year');
    SQL
  end
end
