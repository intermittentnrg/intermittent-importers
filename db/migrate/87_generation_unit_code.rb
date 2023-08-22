class GenerationUnitCode < ActiveRecord::Migration[5.1]
  def change
    change_table :units do |t|
      t.change :code, :string, limit: 100
      #source_id from region
    end
  end
end
