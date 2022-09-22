class PricesDecimalValue < ActiveRecord::Migration[5.1]
  def change
    change_table :prices do |t|
      t.change :value, :decimal, null: false
    end
  end
end
