class Unit < ActiveRecord::Base
  belongs_to :area
  self.inheritance_column = nil
end
