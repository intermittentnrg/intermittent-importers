class AreasProductionType < ActiveRecord::Base
  belongs_to :area
  belongs_to :production_type
  has_many :generation
end
