class GenerationUnitReorderPkey < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE generation_unit
  DROP CONSTRAINT generation_unit_pkey,
  ADD PRIMARY KEY(unit_id,time)
SQL
  end
end
