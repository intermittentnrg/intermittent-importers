class AddCenaceSource < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'cenace'"
    execute "ALTER TYPE regions ADD VALUE 'mexico'"
  end
end
