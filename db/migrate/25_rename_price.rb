class RenamePrice < ActiveRecord::Migration[5.1]
  def change
    rename_table :entsoe_prices, :prices
  end
end
