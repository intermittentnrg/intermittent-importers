class MigratePrice < ActiveRecord::Migration[5.1]
  def change
    change_table :prices do |t|
      t.change :country, :string, null: true
      t.change :area_id, :integer, null: false
    end
  end
end
