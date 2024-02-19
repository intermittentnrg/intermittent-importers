class AddGenerationHiresData < ActiveRecord::Migration[7.0]
  def change
    create_table :generation_hires_data, primary_key: [:unit_id, :time] do |t|
      t.belongs_to :unit, type: :smallint, foreign_key: true
      t.timestamptz :time, null: false
      t.integer :value, null: false
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
SELECT create_hypertable('generation_hires_data', 'time',
       chunk_time_interval => INTERVAL '1 month',
       create_default_indexes => false
)
SQL
      end
    end
  end
end
