class GenerationPjmNuclear < ActiveRecord::Migration[5.1]
  def change
    execute <<-SQL
      ALTER TABLE generation ADD CONSTRAINT pjm_nuclear CHECK (NOT (area_id=118 AND production_type_id=14 AND value>=36000))
    SQL
  end
end
