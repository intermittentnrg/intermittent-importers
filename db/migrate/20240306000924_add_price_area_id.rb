class AddPriceAreaId < ActiveRecord::Migration[7.0]
  def change
    change_table :areas do |t|
      t.integer :price_area_id, limit: 2
    end
  end
end
