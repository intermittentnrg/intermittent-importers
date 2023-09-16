require 'composite_primary_keys'

class Generation < ActiveRecord::Base
  self.table_name = 'generation'
  belongs_to :area
  belongs_to :production_type
end
