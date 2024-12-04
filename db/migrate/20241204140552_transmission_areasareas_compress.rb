class TransmissionAreasareasCompress < ActiveRecord::Migration[7.1]
  def change
    execute "ALTER TABLE transmission_data SET (timescaledb.compress=true, timescaledb.compress_segmentby=areas_area_id)"
    Transmission.chunks.order(:range_start).each do |chunk|
      chunk.compress!
    end
  end
end
