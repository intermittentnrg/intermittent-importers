class AddEskom < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TYPE regions ADD VALUE 'south_africa'"
    execute "ALTER TYPE source_types ADD VALUE 'eskom'"
  end
end
