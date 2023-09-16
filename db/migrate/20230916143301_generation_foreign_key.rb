class GenerationForeignKey < ActiveRecord::Migration[7.0]
  def change
    change_table :generation do |t|
      t.foreign_key :areas
      t.foreign_key :production_types
    end
  end
end
