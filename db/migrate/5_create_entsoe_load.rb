class CreateEntsoeLoad < ActiveRecord::Migration[5.2]
  def change
    create_table :entsoe_load, id: false do |t|
      t.string :country, null: false
      t.integer :value, null: false
      t.datetime :time

      t.index [:time, :country], name: 'unique', unique: true
    end
    execute "SELECT create_hypertable('entsoe_load', 'time');"
  end
end
