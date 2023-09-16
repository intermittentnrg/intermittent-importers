class LoadReorderPkey < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE load
  DROP CONSTRAINT load_pkey,
  ADD PRIMARY KEY(area_id,time)
SQL
  end
end
