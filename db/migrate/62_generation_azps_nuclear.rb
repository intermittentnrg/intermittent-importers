# Palo Verde is double reported in SRP and AZPS until 2019-12-05
class GenerationAzpsNuclear < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE generation ADD CONSTRAINT azps_nuclear CHECK (NOT (area_id=130 AND time<'2019-12-05' AND production_type_id=14))
    SQL
  end
end
