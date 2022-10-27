class GenerationAvrnWind < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE generation ADD CONSTRAINT avrn_wind CHECK (NOT (area_id=156 AND production_type_id=25 AND value>3000))
    SQL
  end
end
