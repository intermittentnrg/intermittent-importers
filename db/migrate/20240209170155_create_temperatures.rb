class CreateTemperatures < ActiveRecord::Migration[7.0]
  def change
    create_table :locations, id: :smallserial do |t|
      t.column :point, :point, null: false
      t.boolean :enabled, null: false, default: true
      t.string :name, null: false
    end
    create_table :temperatures, primary_key: [:location_id, :time] do |t|
      #t.integer :location_id, limit: 2, null: false
      t.belongs_to :location, type: :smallint, foreign_key: true
      t.timestamptz :time, null: false
      t.float :value, null: false
      #t.foreign_key :locations
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
SELECT create_hypertable('temperatures', 'time',
       chunk_time_interval => INTERVAL '1 year',
       create_default_indexes => false
)
SQL
      end
    end
  end
end
