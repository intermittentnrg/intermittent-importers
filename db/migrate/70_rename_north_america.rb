class RenameNorthAmerica < ActiveRecord::Migration[6.1]
  def change
    execute "ALTER TYPE regions RENAME VALUE 'north_america' TO 'usa'"
    execute "ALTER TYPE regions ADD VALUE 'canada'"
  end
end
