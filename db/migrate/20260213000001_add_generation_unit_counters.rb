class AddGenerationUnitCounters < ActiveRecord::Migration[7.1]
  def change
    hypertable_options = {
      time_column: 'time',
      chunk_time_interval: '1 year',
      compress_segmentby: 'unit_id',
      compress_after: '7 days',
      compress_orderby: 'time DESC',
      create_default_indexes: false
    }

    create_table :generation_unit_counters, primary_key: [:unit_id, :time], hypertable: hypertable_options do |t|
      t.timestamptz :time, null: false
      t.integer :unit_id, limit: 2, null: false
      t.bigint :value, null: false
    end
  end
end
