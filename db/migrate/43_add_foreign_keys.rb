class AddForeignKeys < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :transmission, :areas, column: :from_area_id
    add_foreign_key :transmission, :areas, column: :to_area_id

    add_foreign_key :prices, :areas
    add_foreign_key :load, :areas
    add_foreign_key :generation, :production_types
  end
end
