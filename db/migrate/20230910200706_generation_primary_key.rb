class GenerationPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TABLE generation ADD PRIMARY KEY (time, area_id, production_type_id)"
  end
end
