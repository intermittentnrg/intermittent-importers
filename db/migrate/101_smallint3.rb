class Smallint3 < ActiveRecord::Migration[5.2]
  def change
    change_table :generation do |t|
      t.change :area_id, :integer, null: false, limit: 2
    end
  end
end
