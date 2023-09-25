class CreateCapacity < ActiveRecord::Migration[7.0]
  def change
    create_table :capacities, primary_key: [:area_id, :production_type_id, :time]  do |t|
      t.integer :area_id, limit: 2, null: false
      t.integer :production_type_id, limit: 2, null: false
      t.timestamptz :time, null: false
      t.integer :value, null: false
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
SELECT create_hypertable('capacities', 'time',
       chunk_time_interval => INTERVAL '1 year',
       create_default_indexes => false
)
SQL
      end
    end
  end
end
