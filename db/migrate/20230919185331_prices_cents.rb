class PricesCents < ActiveRecord::Migration[7.0]
  def change
    change_table :prices do |t|
      t.change :value, :integer, null: false, limit: 4
    end
    execute "UPDATE prices SET value=value*100"
  end
end
