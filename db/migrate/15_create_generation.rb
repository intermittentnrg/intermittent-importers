class CreateGeneration < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
CREATE TYPE source_types AS ENUM('entsoe','elexon','svk_mimer','svk_controlroom')
SQL
      end
      dir.down do
        execute "DROP TYPE source_types"
      end
    end
    create_table :areas do |t|
      t.string :code
      t.string :entsoe_id
      t.boolean :is_country
      t.column :source, 'source_types', null: false
    end
    create_table :generation, id: false do |t|
      t.integer :area_id, null: false
      t.column :production_type, 'entsoe_production_types', null: false
      #t.column :production_type, 'entsoe_production_types USING production_type::entsoe_production_types', null: false
      t.integer :value, null: false
      t.timestamp :time, null: false
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index [:time, :area_id, :production_type], name: 'generation_unique', unique: true
      t.foreign_key :areas, column: :area_id
    end
    reversible do |dir|
      dir.up do
        execute "SELECT create_hypertable('generation', 'time', chunk_time_interval => INTERVAL '1 year');"
        execute <<-SQL
CREATE TRIGGER trigger_set_updated_at BEFORE UPDATE ON generation
  FOR EACH ROW EXECUTE PROCEDURE trigger_set_updated_at ();
SQL
      end
    end
  end
end
