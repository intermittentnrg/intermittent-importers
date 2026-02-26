class AreasTimezone < ActiveRecord::Migration[7.1]
  def change
    change_table :areas do |t|
      t.string :timezone
      t.integer :timezone_priority, limit: 2
    end
  end
end
