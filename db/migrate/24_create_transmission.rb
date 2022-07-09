class CreateTransmission < ActiveRecord::Migration[5.2]
  def change
    create_table :transmission, id: false do |t|
      t.integer :from_area_id, null: false
      t.integer :to_area_id, null: false
      t.integer :value, null: false
      t.timestamp :time, null: false
      t.timestamp :created_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.timestamp :updated_at, null: false, default: -> { "CURRENT_TIMESTAMP" }
      t.index [:time]
      t.index :from_area_id
      t.index :to_area_id
    end
    reversible do |dir|
      dir.up do
        execute "SELECT create_hypertable('transmission', 'time');"
        execute <<-SQL
CREATE TRIGGER trigger_set_updated_at BEFORE UPDATE ON transmission
  FOR EACH ROW EXECUTE PROCEDURE trigger_set_updated_at ();
SQL
      end
    end
  end
end
