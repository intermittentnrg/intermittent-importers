class Unit < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :area
  belongs_to :production_type
end
