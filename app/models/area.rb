class Area < ActiveRecord::Base
  self.inheritance_column = nil
  has_many :generation
  has_many :load
end
