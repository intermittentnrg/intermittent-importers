class AddLocationIdToAreas < ActiveRecord::Migration[7.0]
  def change
    change_table :areas do |t|
      t.belongs_to :location, type: :smallint, foreign_key: true
    end
  end
end
