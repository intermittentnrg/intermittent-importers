class AreasTimezoneNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column :areas, :timezone, :string, null: false
  end
end
