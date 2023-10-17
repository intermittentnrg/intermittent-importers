class GenerationAptPkey < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TABLE generation
        ALTER COLUMN areas_production_types_id SET NOT NULL,
        DROP CONSTRAINT generation_pkey,
        ADD PRIMARY KEY(areas_production_types_id, time)
    SQL
  end
end
