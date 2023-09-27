class GenerationUnitCapacities < ActiveRecord::Migration[7.0]
  def change
    create_table :generation_unit_capacities, primary_key: [:unit_id, :time]  do |t|
      t.integer :unit_id, limit: 2, null: false
      t.timestamptz :time, null: false
      t.integer :value, null: false
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
SELECT create_hypertable('generation_unit_capacities', 'time',
       chunk_time_interval => INTERVAL '1 year',
       create_default_indexes => false
)
SQL
      end
    end
  end
end
