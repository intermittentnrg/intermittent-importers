class GenerationUnitCounter < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :unit
end
