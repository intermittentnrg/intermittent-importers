class UnitProductionType < ActiveRecord::Base
  belongs_to :unit
  belongs_to :production_type
end
