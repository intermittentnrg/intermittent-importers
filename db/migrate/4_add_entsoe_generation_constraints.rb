class AddEntsoeGenerationConstraints < ActiveRecord::Migration[5.1]
  def up
    execute <<-SQL
      ALTER TABLE entsoe_generation ADD CONSTRAINT no_wind_onshore CHECK (NOT (country='NO' AND production_type='wind_onshore' AND value > 10000))
    SQL
  end

  def down
    execute <<-SQL
      ALTER TABLE entsoe_generation DROP CONSTRAINT no_wind_onshore
    SQL
  end
end
