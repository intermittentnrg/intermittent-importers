class TransmissionAreasareasDecompress < ActiveRecord::Migration[7.1]
  def up
    Transmission.chunks.order(:range_start).each do |chunk|
      chunk.decompress!
    end
    execute "ALTER TABLE transmission_data SET (timescaledb.compress=false)"
  end
end
