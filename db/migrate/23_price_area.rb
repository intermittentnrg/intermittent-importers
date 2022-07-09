class PriceArea < ActiveRecord::Migration[5.1]
  def change
    change_table :entsoe_prices do |t|
      t.integer :area_id
    end
    execute <<-EOF
UPDATE entsoe_prices p
SET area_id=a.id
FROM areas a WHERE (a.code=p.country AND a.source='entsoe')
    EOF
  end
end
