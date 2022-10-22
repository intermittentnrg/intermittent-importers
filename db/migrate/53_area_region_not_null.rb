class AreaRegionNotNull < ActiveRecord::Migration[5.1]
  def change
    change_table :areas do |t|
      t.change :region, 'regions', null: false
    end
  end
end
