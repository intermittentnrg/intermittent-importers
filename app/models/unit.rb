class Unit < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :area
  belongs_to :production_type
  belongs_to :areas_production_type
end
