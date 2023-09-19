class PricesSmallint < ActiveRecord::Migration[7.0]
  def change
    change_table :prices do |t|
      t.change :value, :integer, null: false, limit: 2
    end
  end
end
