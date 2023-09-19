class GenerationCaptureCents < ActiveRecord::Migration[7.0]
  def change
    reversible do |dir|
      dir.up do
        change_table :generation_capture do |t|
          t.change :price, :integer, null: false, limit: 4
          t.change :revenue, :integer, null: false, limit: 8
        end
      end
    end
  end
end
