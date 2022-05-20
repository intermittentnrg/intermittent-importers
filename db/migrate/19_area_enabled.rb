class AreaEnabled < ActiveRecord::Migration[5.2]
  def change
    change_table :areas do |t|
      t.boolean :enabled, default: true
    end
  end
end
