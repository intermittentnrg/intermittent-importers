class LoadInKwh < ActiveRecord::Migration[5.2]
  def change
    execute "UPDATE load SET value=value*1000"
  end
end
