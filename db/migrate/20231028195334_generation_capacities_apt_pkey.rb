class GenerationCapacitiesAptPkey < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
      ALTER TABLE generation_capacities_data
        ALTER COLUMN areas_production_type_id SET NOT NULL,
        DROP CONSTRAINT capacities_pkey,
        ADD PRIMARY KEY(areas_production_type_id, time)
    SQL
  end
end
