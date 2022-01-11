class CreateEntsoePrices < ActiveRecord::Migration[5.2]
  def change
    create_table :entsoe_prices, id: false do |t|
      t.string :country, null: false
      t.integer :value, null: false

      t.timestamp :time, null: false
      t.timestamp :created_at, null: false, default: "CURRENT_TIMESTAMP"
      t.timestamp :updated_at, null: false, default: "CURRENT_TIMESTAMP"
      t.index [:time, :country], name: 'entsoe_prices_unique', unique: true
    end
    execute "SELECT create_hypertable('entsoe_prices', 'time');"
    reversible do |dir|
      dir.up do
        execute <<-SQL
CREATE TRIGGER trigger_set_updated_at BEFORE UPDATE ON entsoe_prices
  FOR EACH ROW EXECUTE PROCEDURE trigger_set_updated_at ();
SQL
      end
    end
  end
end
