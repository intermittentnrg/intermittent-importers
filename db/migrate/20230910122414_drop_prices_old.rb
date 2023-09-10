class DropPricesOld < ActiveRecord::Migration[7.0]
  def change
    drop_table :prices_old
  end
end
