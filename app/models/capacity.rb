require 'composite_primary_keys'

class Capacity < ActiveRecord::Base
  belongs_to :area
  belongs_to :production_type
end
