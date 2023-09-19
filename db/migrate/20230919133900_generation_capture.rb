class GenerationCapture < ActiveRecord::Migration[7.0]
  def change
    create_table :generation_capture, primary_key: [:area_id, :production_type_id, :time] do |t|
      t.timestamptz :time, null: false, index: false
      t.integer :area_id, limit: 2, null: false
      t.integer :production_type_id, limit: 2, null: false
      t.integer :kwh, null: false
      t.integer :price, limit: 2, null: false
      t.integer :revenue, null: false
      t.foreign_key :areas
      t.foreign_key :production_types
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
          SELECT create_hypertable('generation_capture','time',
            chunk_time_interval => INTERVAL '1 year',
            create_default_indexes => false
          );
        SQL
      end
    end
  end
end
