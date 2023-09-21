class GenerationCaptureGeneratedConsumed < ActiveRecord::Migration[7.0]
  def change
    change_table :generation_capture do |t|
      t.integer :kwh_generated, null: false, default: 0
      t.integer :kwh_consumed, null: false, default: 0
      t.integer :revenue_generated, null: false, default: 0, limit: 8
      t.integer :revenue_consumed, null: false, default: 0, limit: 8
    end
  end
end
