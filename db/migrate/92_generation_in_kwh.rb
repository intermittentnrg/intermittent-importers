class GenerationInKwh < ActiveRecord::Migration[5.2]
  def change
    execute "UPDATE generation SET value=value*1000"
  end
end
