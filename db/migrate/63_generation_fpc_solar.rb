class GenerationFpcSolar < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE generation ADD CONSTRAINT fpc_solar CHECK (NOT (area_id=122 AND production_type_id=17 AND value>1000))
    SQL
  end
end
