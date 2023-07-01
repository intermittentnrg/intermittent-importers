class LoadAreasDeleteRestrict < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :load, :areas
    add_foreign_key :load, :areas, on_delete: :restrict
  end
end
