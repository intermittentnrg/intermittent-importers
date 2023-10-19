class SourceTohokuEpco < ActiveRecord::Migration[7.0]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'tohoku-epco'"
  end
end
