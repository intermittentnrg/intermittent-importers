class PrimaryKeyGeneration < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        execute "DROP INDEX generation_unique"
        execute "ALTER TABLE generation ADD PRIMARY KEY (area_id,production_type,time)"
      end
    end
  end
end
