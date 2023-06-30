class ProductionTypesDeleteRestrict < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :generation, :production_types
    add_foreign_key :generation, :production_types, on_delete: :restrict
  end
end
