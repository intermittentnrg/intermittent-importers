class ProductionType < ActiveRecord::Base
  belongs_to :production_type_group
  has_many :areas_production_type
end
