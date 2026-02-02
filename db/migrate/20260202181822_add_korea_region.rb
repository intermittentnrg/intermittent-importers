class AddKoreaRegion < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TYPE regions ADD VALUE 'korea'"
  end
end
