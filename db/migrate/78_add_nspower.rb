class AddNspower < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'nspower'"
  end
end
