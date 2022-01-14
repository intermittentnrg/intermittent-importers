class CreateElexonGeneration < ActiveRecord::Migration[5.2]
  def change
    create_table :elexon_generation, id: false do |t|
      t.string :production_type, null: false
      t.integer :value, null: false
      t.timestamp :time, null: false
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index [:time, :production_type], name: 'elexon_generation_unique', unique: true
    end
    reversible do |dir|
      dir.up do
        execute "SELECT create_hypertable('elexon_generation', 'time');"
        execute <<-SQL
CREATE TRIGGER trigger_set_updated_at BEFORE UPDATE ON elexon_generation
  FOR EACH ROW EXECUTE PROCEDURE trigger_set_updated_at ();
SQL
      end
    end
  end
end
