class LoadPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TABLE load ADD PRIMARY KEY (time, area_id)"
  end
end
