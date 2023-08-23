class Unit < ActiveRecord::Base
  belongs_to :area
  belongs_to :production_type
  self.inheritance_column = nil
end
