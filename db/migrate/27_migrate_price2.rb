class MigratePrice2 < ActiveRecord::Migration[5.1]
  def change
    change_table :prices do |t|
      t.remove :country
    end
  end
end
