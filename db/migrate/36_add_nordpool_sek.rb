class AddNordpoolSek < ActiveRecord::Migration[5.1]
  def change
    reversible do |dir|
      dir.up do
        execute "ALTER TYPE source_types ADD VALUE 'nordpool_sek'"
      end
    end
  end
end
