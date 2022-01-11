class RenameEntsoeGenerationTime < ActiveRecord::Migration[5.2]
  def change
    change_table :entsoe_generation do |t|
      t.rename :created_at, :time
      t.timestamp :created_at, default: "CURRENT_TIMESTAMP"
    end
    change_table :entsoe_load do |t|
      t.timestamp :created_at, default: "CURRENT_TIMESTAMP"
    end
  end
end
