class AddKpxSource < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'kpx'"
  end
end
