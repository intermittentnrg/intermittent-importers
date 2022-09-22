class RenameAreaNames < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        execute "UPDATE areas SET code=REPLACE(code,'SE-','') WHERE code LIKE 'SE-%'"
        execute "UPDATE areas SET code=REPLACE(code,'DK-','') WHERE code LIKE 'DK-%'"
        execute "UPDATE areas SET code=REPLACE(code,'NO-','') WHERE code LIKE 'NO-%'"
      end
    end
  end
end
