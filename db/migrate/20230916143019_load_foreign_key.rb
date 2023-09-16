class LoadForeignKey < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :load, :areas
  end
end
