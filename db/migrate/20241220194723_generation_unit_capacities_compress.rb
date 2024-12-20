class GenerationUnitCapacitiesCompress < ActiveRecord::Migration[7.1]
  def change
    add_compression_policy(:generation_unit_capacities,
                           orderby: :time,
                           segmentby: :unit_id,
                           compress_after: '1 year')
  end
end
