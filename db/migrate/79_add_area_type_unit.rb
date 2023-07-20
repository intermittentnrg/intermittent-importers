class AddAreaTypeUnit < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TYPE area_types ADD VALUE 'unit'"
  end
end
