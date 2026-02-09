class Unit < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :area
  belongs_to :production_type
  has_many :unit_names
  has_many :unit_production_types
end
