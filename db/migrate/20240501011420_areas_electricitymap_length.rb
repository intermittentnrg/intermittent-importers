class AreasElectricitymapLength < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        change_table :areas do |t|
          t.change :electricitymaps_id, :string, limit: 12
        end
      end
    end
  end
end
