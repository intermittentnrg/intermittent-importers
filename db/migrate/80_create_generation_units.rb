class CreateGenerationUnits < ActiveRecord::Migration[5.1]
  def change
    create_table :generation_units, id: false do |t|
      t.integer :unit_id, null: false
      t.timestamp :time, null: false
      t.integer :value
    end
    reversible do |dir|
      dir.up do
        execute "ALTER TABLE generation_units ADD PRIMARY KEY (unit_id,time)"
      end
    end
    create_table :units do |t|
      t.integer :area_id
      t.integer :production_type_id
      t.string :internal_id
      t.string :code, limit: 15
      #source_id from region
    end
  end
end
