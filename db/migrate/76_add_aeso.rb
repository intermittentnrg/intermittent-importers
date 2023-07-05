class AddAeso < ActiveRecord::Migration[5.1]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'aeso'"
  end
end
