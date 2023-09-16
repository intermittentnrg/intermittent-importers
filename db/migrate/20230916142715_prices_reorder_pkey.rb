class PricesReorderPkey < ActiveRecord::Migration[7.0]
  def change
    execute <<-SQL
ALTER TABLE prices
  DROP CONSTRAINT prices_pkey,
  ADD PRIMARY KEY(area_id,time)
SQL
  end
end
