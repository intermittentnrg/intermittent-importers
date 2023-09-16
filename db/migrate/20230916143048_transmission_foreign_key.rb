class TransmissionForeignKey < ActiveRecord::Migration[7.0]
  def change
    change_table :transmission do |t|
      t.foreign_key :areas, column: :from_area_id
      t.foreign_key :areas, column: :to_area_id
    end
  end
end
