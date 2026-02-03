class AddIndia < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'grid-india'"
    execute "ALTER TYPE regions ADD VALUE 'india'"
  end
end
