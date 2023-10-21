require './lib/init'
@logger = logger = SemanticLogger['Rakefile']

require 'active_record_migrations'
ActiveRecordMigrations.load_tasks
ActiveRecordMigrations.configure do |c|
  c.schema_format = :sql
end
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz

#ActiveRecord::Base.logger = Logger.new(STDOUT)

def pump_task(name, source)
  desc "Run refresh task"
  task name do |t|
    SemanticLogger.tagged(task: t.to_s) do
      Pump::Process.new(source).run
    rescue
      @logger.error "Exception", $!
    end
  end
end

def loop_task(name, clazz)
  desc "Run refresh task"
  task name do |t|
    SemanticLogger.tagged(task: t.to_s) do
      clazz.each &:process
    rescue
      @logger.error "Exception", $!
    end
  end
end

def oneshot_task(name, clazz)
  desc "Run refresh task"
  task name do |t|
    SemanticLogger.tagged(task: t.to_s) do
      clazz.new.process
    rescue
      @logger.error "Exception", $!
    end
  end
end

task :ping do |t|
  SemanticLogger.tagged(task: t.to_s) { logger.info "ping" }
end

desc "Run all refresh tasks"
multitask all: ['entsoe:all', 'aemo:all', 'ieso:all', 'eia:all', :ercot, 'caiso:all', 'elexon:all', 'nordpool:all', :opennem, :ree, :aeso, :hydroquebec, :tohoku]
namespace :ieso do
  desc "Run refresh tasks"
  task all: [:generation, :load, :price]
  pump_task :generation, Ieso::Generation
  pump_task :load, Ieso::Load
  pump_task :price, Ieso::Price
end

namespace :eia do
  desc "Run refresh tasks"
  task all: [:generation, :load]
  pump_task :generation, Eia::Generation
  pump_task :load, Eia::Load
end

oneshot_task :ercot, Ercot::Generation

namespace :caiso do
  desc "Run refresh tasks"
  task all: [:generation, :load]
  pump_task :generation, Caiso::Generation
  pump_task :load, Caiso::Load
end

namespace :elexon do
  desc "Run refresh tasks"
  task all: [:generation, :fuelinst, :load, :unit]
  pump_task :generation, Elexon::Generation
  pump_task :fuelinst, Elexon::Fuelinst
  pump_task :load, Elexon::Load
  pump_task :unit, Elexon::Unit
end

namespace :entsoe do
  desc "Run refresh tasks"
  task all: [:generation, :unit, :load, :price, :transmission]
  loop_task :generation, EntsoeSFTP::Generation
  loop_task :unit, EntsoeSFTP::Unit
  loop_task :load, EntsoeSFTP::Load
  loop_task :price, EntsoeSFTP::Price
  pump_task :transmission, ENTSOE::Transmission
end

namespace :nordpool do
  desc "Run refresh tasks"
  task all: [:transmission, :capacity, :price]
  pump_task :transmission, Nordpool::Transmission
  pump_task :capacity, Nordpool::Capacity
  pump_task :price, Nordpool::Price
  pump_task :price_sek, Nordpool::PriceSEK
end

oneshot_task :opennem, Opennem::Latest

namespace :aemo do
  desc "Run refresh tasks"
  task all: ['nem:all', 'wem:all']
  namespace :nem do
    desc "Run refresh tasks"
    task all: [:trading, :dispatch, :scada, :rooftoppv]
    loop_task :trading, AemoNem::Trading
    loop_task :dispatch, AemoNem::Dispatch
    loop_task :scada, AemoNem::Scada
    loop_task :rooftoppv, AemoNem::RooftopPv
  end
  namespace :wem do
    desc "Run refresh tasks"
    task all: [:balancing, :scada, :distributed_pv]
    oneshot_task :scada, AemoWem::ScadaLive
    oneshot_task :distributed_pv, AemoWem::DistributedPvLive
    #loop_task :balancing, AemoWem::Balancing
    oneshot_task :balancing, AemoWem::BalancingLive
  end
end

pump_task :ree, Ree::Generation

desc "Run refresh tasks"
task :aeso do |t|
  SemanticLogger.tagged(task: t.to_s) do
    Aeso::Generation.new.process
  rescue
    logger.error "Exception", $!
  end
end

task :hydroquebec do |t|
  SemanticLogger.tagged(task: t.to_s) do
    HydroQuebec::Generation.new.process
  rescue
    logger.error "Exception", $!
  end
end

# task :nspower do
#   Nspower::Combined.new.process
# rescue
#   logger.error "Exception", $!
# end

pump_task :tohoku, Tohoku::Juyo

task :fixtures_areas do
  File.open("test/fixtures/areas.yml", 'w') do |f|
    Area.order(:source, :code).all.each do |a|
      f.write({"#{a.source}_#{a.code}" => a.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end
task :fixtures_pt do
  File.open("test/fixtures/production_types.yml", 'w') do |f|
    ProductionType.order(:name).all.each do |pt|
      f.write({"#{pt.name}" => pt.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end
task :fixtures_apt do
  File.open("test/fixtures/areas_production_types.yml", 'w') do |f|
    AreasProductionType.order(:area_id).all.each do |apt|
      f.write({"#{apt.area.code}_#{apt.production_type.name}" => apt.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end
