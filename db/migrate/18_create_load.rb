class CreateLoad < ActiveRecord::Migration[5.2]
  def change
    create_table :load, id: false do |t|
      t.integer :value, null: false
      t.integer :area_id, null: false
      t.timestamp :time, null: false
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index [:time], name: 'load_unique', unique: true
    end
    reversible do |dir|
      dir.up do
        execute "SELECT create_hypertable('load', 'time');"
        execute <<-SQL
CREATE TRIGGER trigger_set_updated_at BEFORE UPDATE ON load
  FOR EACH ROW EXECUTE PROCEDURE trigger_set_updated_at ();
SQL
      end
    end
  end
end
