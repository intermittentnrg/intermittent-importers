class AreasDeleteRestrict < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :generation, :areas
    add_foreign_key :generation, :areas, on_delete: :restrict
  end
end
