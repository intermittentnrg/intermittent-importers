class Area < ActiveRecord::Base
  self.inheritance_column = nil
  belongs_to :location
  has_many :load
  has_many :units
  has_many :prices
  has_many :areas_production_type
  has_many :from_areas, foreign_key: :from_area_id, class_name: 'AreasArea'
  has_many :to_areas, foreign_key: :to_area_id, class_name: 'AreasArea'
end
