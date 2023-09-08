class GenerationUnitPrimaryKey < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TABLE generation_unit ADD PRIMARY KEY (time, unit_id)"
  end
end
