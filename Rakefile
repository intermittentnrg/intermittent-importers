require './lib/init'
require './lib/activerecord-connect'

@logger = logger = SemanticLogger['Rakefile']

db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

include ActiveRecord::Tasks
DatabaseTasks.env = ENV['ENV'] || 'development'
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.unsafe_load(ERB.new(File.read(File.join(config_dir, 'database.yaml'))).result)
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
  #ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.schema_format = :sql
  ActiveRecord::Base.dump_schema_after_migration = false
  #ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'

def pump_task(name, source, model)
  task name do
    Pump::Process.new(source, model).run
  rescue
    @logger.error "Exception", $!
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
  task all: [:generation, :fuelinst, :load]
  pump_task :generation, Elexon::Generation, Generation
  pump_task :fuelinst, Elexon::Fuelinst, Generation
  pump_task :load, Elexon::Load, Load
end

namespace :entsoe do
  task all: [:generation, :load, :transmission, :price]
  pump_task :generation, ENTSOE::Generation, Generation
  pump_task :load, ENTSOE::Load, Load
  pump_task :transmission, ENTSOE::Transmission, Transmission
  pump_task :price, ENTSOE::Price, Price
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
