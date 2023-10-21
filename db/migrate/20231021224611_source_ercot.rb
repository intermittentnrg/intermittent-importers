class SourceErcot < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'ercot'"
  end
end
