require './lib/init'
require './lib/activerecord-connect'
Rails.application = Class.new do
  def self.eager_load!
    Area
    AreasProductionType
    Capacity
    #DataFile
    Generation
    GenerationUnitCapacity
    GenerationUnitHires
    GenerationUnit
    Load
    Location
    Price
    ProductionType
    Temperature
    Transmission
    Unit
  end
  def self.config
  end
end
