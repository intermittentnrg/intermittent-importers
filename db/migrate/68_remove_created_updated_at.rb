class RemoveCreatedUpdatedAt < ActiveRecord::Migration[6.1]
  def change
    change_table :generation do |t|
      t.remove :created_at
      t.remove :updated_at
    end
    change_table :load do |t|
      t.remove :created_at
      t.remove :updated_at
    end
    change_table :prices do |t|
      t.remove :created_at
      t.remove :updated_at
    end
  end
end
