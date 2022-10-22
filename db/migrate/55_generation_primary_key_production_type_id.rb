class GenerationPrimaryKeyProductionTypeId < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TABLE generation ADD PRIMARY KEY (area_id,production_type_id,time)"
  end
end
