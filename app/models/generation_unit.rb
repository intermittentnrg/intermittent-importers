require 'composite_primary_keys'

class GenerationUnit < ActiveRecord::Base
  self.table_name = 'generation_unit'
  #self.primary_keys = :time, :unit_id
  belongs_to :unit


  def self.aggregate_to_generation(where)
    r = connection.exec_query <<-SQL
      INSERT INTO generation (time, area_id, production_type_id, value)
      SELECT time, u.area_id, u.production_type_id, SUM(value) AS value
      FROM generation_unit g
      INNER JOIN units u ON(g.unit_id=u.id)
      INNER JOIN areas a ON(u.area_id=a.id)
      WHERE #{where}
      GROUP BY 1,2,3
      ON CONFLICT ("time", area_id, production_type_id) DO UPDATE set value = EXCLUDED.value
    SQL
    # require 'pry' ; binding.pry
  end
end
