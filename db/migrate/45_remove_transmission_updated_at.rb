class RemoveTransmissionUpdatedAt < ActiveRecord::Migration[5.1]
  def change
    change_table :transmission do |t|
      t.remove :updated_at
      t.remove :created_at
    end
  end
end
