class PricesForeignKey < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :prices, :areas
  end
end
