class RemoveOldAreasColumns < ActiveRecord::Migration[5.1]
  def change
    change_table :areas do |t|
      t.change :code, :string, null: false, limit: 15
      t.remove :is_country
      t.change :enabled, :boolean, null: false, default: true
      t.change :type, 'area_types', null: false
    end
  end
end
