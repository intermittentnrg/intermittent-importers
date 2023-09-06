require './lib/init'
@logger = logger = SemanticLogger['Rakefile']

require 'active_record_migrations'
ActiveRecordMigrations.load_tasks
ActiveRecordMigrations.configure do |c|
  c.schema_format = :sql
end

def pump_task(name, source, model)
  task name do
    Pump::Process.new(source, model).run
  rescue
    @logger.error "Exception", $!
  end
end

def loop_task(name, clazz)
  task name do
    clazz.each &:process
  end
end

task :ping do
  logger.info "ping"
end

multitask all: ["ieso:all", "eia:all", "caiso:generation", "elexon:all", "entsoe:all", "nordpool:all", :opennem, :ree, :aeso, :hydroquebec]
namespace :ieso do
  task all: [:generation, :load]
  pump_task :generation, Ieso::Generation, Generation
  pump_task :load, Ieso::Load, Load
end

namespace :eia do
  task all: [:generation, :load]
  pump_task :generation, Eia::Generation, Generation
  pump_task :load, Eia::Load, Load
end

namespace :caiso do
  pump_task :generation, Caiso::Generation, Generation
end

namespace :elexon do
  task all: [:generation, :fuelinst, :load, :unit]
  pump_task :generation, Elexon::Generation, Generation
  pump_task :fuelinst, Elexon::Fuelinst, Generation
  pump_task :load, Elexon::Load, Load
  pump_task :unit, Elexon::Unit, GenerationUnit
end

namespace :entsoe do
  task all: [:generation, :load, :transmission, :price]
  loop_task :generation, EntsoeSFTP::Generation
  loop_task :unit, EntsoeSFTP::Unit
  loop_task :load, EntsoeSFTP::Load
  loop_task :price, EntsoeSFTP::Price
  #pump_task :generation, ENTSOE::Generation, Generation
  #pump_task :load, ENTSOE::Load, Load
  pump_task :transmission, ENTSOE::Transmission, Transmission
  #pump_task :price, ENTSOE::Price, Price
end

namespace :nordpool do
  task all: [:transmission, :capacity, :price]
  pump_task :transmission, Nordpool::Transmission, Transmission
  pump_task :capacity, Nordpool::Capacity, Transmission
  pump_task :price, Nordpool::Price, Price
end

task :opennem do
  Opennem::Latest.new.process
rescue
  logger.error "Exception", $!
end

pump_task :ree, Ree::Generation, Generation

task :aeso do
  Aeso::Generation.new.process
rescue
  logger.error "Exception", $!
end

task :hydroquebec do
  HydroQuebec::Generation.new.process
rescue
  logger.error "Exception", $!
end

# task :nspower do
#   Nspower::Combined.new.process
# rescue
#   logger.error "Exception", $!
# end
