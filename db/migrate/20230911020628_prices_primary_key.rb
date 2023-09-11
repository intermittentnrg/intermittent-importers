class PricesPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TABLE prices ADD PRIMARY KEY (time, area_id)"
  end
end
