class AddAreasElectricitymapsId < ActiveRecord::Migration[5.1]
  def change
    change_table :areas do |t|
      t.string :electricitymaps_id, limit: 10
    end
  end
end
