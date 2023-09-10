class DropTransmissionAndLoadOld < ActiveRecord::Migration[7.0]
  def change
    drop_table :transmission_old
    drop_table :load_old
  end
end
