require 'composite_primary_keys'

class Capacity < ActiveRecord::Base
  self.table_name = 'generation_capacities_data'
  belongs_to :area
  belongs_to :production_type
  belongs_to :areas_production_type
end
