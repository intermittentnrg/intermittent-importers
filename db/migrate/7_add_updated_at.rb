class AddUpdatedAt < ActiveRecord::Migration[5.2]
  def change
    change_table :entsoe_generation do |t|
      t.change :updated_at, :timestamp, null: false, default: "CURRENT_TIMESTAMP"
    end
    change_table :entsoe_load do |t|
      t.timestamp :updated_at, null: false, default: "CURRENT_TIMESTAMP"
    end
    reversible do |dir|
      dir.up do
        execute <<-SQL
CREATE OR REPLACE FUNCTION trigger_set_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_set_updated_at BEFORE UPDATE ON entsoe_generation
  FOR EACH ROW EXECUTE PROCEDURE trigger_set_updated_at (updated_at);

CREATE TRIGGER trigger_set_updated_at BEFORE UPDATE ON entsoe_load
  FOR EACH ROW EXECUTE PROCEDURE trigger_set_updated_at (updated_at);
SQL
      end
    end
  end
end
