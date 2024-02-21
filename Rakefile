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
multitask all: ['entsoe:all', 'aemo:all', 'ieso:all', 'eia:all', :ercot, 'caiso:all', 'elexon:all', :nationalgrideso, 'nordpool:all', :opennem, :ree, :aeso, :hydroquebec, :tohoku, 'eskom:all']
namespace :ieso do
  desc "Run refresh tasks"
  task all: [:unit, :load, :price, :intertie]
  loop_task :unit, Ieso::Unit
  loop_task :load, Ieso::Load
  loop_task :price, Ieso::Price
  pump_task :intertie, Ieso::Intertie
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
  task all: [:generation, :fuelinst, :load, :unit, :interfuelhh]
  pump_task :generation, Elexon::Generation
  pump_task :fuelinst, Elexon::Fuelinst
  pump_task :interfuelhh, Elexon::Interfuelhh
  pump_task :load, Elexon::Load
  pump_task :unit, Elexon::Unit
end

pump_task :nationalgrideso, NationalGridEso::DemandLive

namespace :entsoe do
  desc "Run refresh tasks"
  task all: [:generation, :unit, :load, :price, :transmission]
  loop_task :generation, EntsoeSftp::Generation
  loop_task :unit, EntsoeSftp::Unit
  loop_task :load, EntsoeSftp::Load
  loop_task :price, EntsoeSftp::Price
  loop_task :transmission, EntsoeSftp::Transmission
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
    task all: [:trading, :dispatch, :scada, :rooftoppv, :causer_pays]
    loop_task :trading, AemoNem::Trading
    loop_task :dispatch, AemoNem::Dispatch
    loop_task :scada, AemoNem::Scada
    loop_task :rooftoppv, AemoNem::RooftopPv
    loop_task :causer_pays, AemoNem::CauserPays
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

namespace :eskom do
  task all: [:generation, :demand]
  oneshot_task :generation, Eskom::Generation
  oneshot_task :demand, Eskom::Demand
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

desc 'Export areas to test/fixtures/areas.yml'
task :fixtures_areas do
  File.open("test/fixtures/areas.yml", 'w') do |f|
    Area.order(:source, :code).all.each do |a|
      f.write({"#{a.source}_#{a.code}" => a.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end

desc 'Export production types to test/fixtures/production_types.yml'
task :fixtures_pt do
  File.open("test/fixtures/production_types.yml", 'w') do |f|
    ProductionType.order(:name).all.each do |pt|
      f.write({"#{pt.name}" => pt.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end

desc 'Export area production types to test/fixtures/areas_production_types.yml'
task :fixtures_apt do
  File.open("test/fixtures/areas_production_types.yml", 'w') do |f|
    AreasProductionType.order(:area_id, :production_type_id).all.each do |apt|
      f.write({"#{apt.area.code}_#{apt.production_type.name}" => apt.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end
