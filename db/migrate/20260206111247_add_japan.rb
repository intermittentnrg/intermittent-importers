class AddJapan < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TYPE source_types ADD VALUE 'tepco'"
    execute "ALTER TYPE source_types ADD VALUE 'chuden'"
    execute "ALTER TYPE source_types ADD VALUE 'hepco'"
    execute "ALTER TYPE source_types ADD VALUE 'rikuden'"
    execute "ALTER TYPE source_types ADD VALUE 'okiden'"
    execute "ALTER TYPE source_types ADD VALUE 'chugoku'"
    execute "ALTER TYPE source_types ADD VALUE 'yonden'"
    execute "ALTER TYPE source_types ADD VALUE 'kyuden'"
    execute "ALTER TYPE source_types ADD VALUE 'kepco'"
  end
end
