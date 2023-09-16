class GenerationReorderPkey < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE generation
  DROP CONSTRAINT generation_pkey,
  ADD PRIMARY KEY(area_id,production_type_id,time)
SQL
  end
end
