class CreateEntsoeGeneration < ActiveRecord::Migration[5.2]
  def change
    create_table :entsoe_generation, id: false do |t|
      t.string :country, null: false
      t.string :production_type, null: false
      t.string :process_type
      t.string :business_type
      t.integer :value, null: false

      t.timestamps
      t.index [:created_at, :country, :production_type, :process_type], name: 'intermittency_unique', unique: true
    end
    execute "SELECT create_hypertable('entsoe_generation', 'created_at');"
  end
end
