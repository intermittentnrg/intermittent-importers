class AreasLongerCode < ActiveRecord::Migration[7.1]
  def change
    change_table :areas do |t|
      t.change :code, :string, null: false, limit: 20
      t.change :internal_id, :string, null: false, limit: 20
    end
  end
end
