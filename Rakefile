require './lib/init'
@logger = logger = SemanticLogger['Rakefile']

require 'active_record_migrations'
ActiveRecordMigrations.load_tasks
ActiveRecordMigrations.configure do |c|
  c.schema_format = :sql
end
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz
unless Rails.env.test?
  ActiveRecord::ConnectionAdapters::AbstractAdapter.set_callback :checkout, :after do |conn|
    conn.exec_query "SET timescaledb.max_tuples_decompressed_per_dml_transaction TO 1000000"
  end
end
#ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveSupport.on_load(:active_record) { extend Timescaledb::ActsAsHypertable }

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

def chain_task(name, clazz)
  desc "Run refresh task with chaining API"
  task name do |t|
    SemanticLogger.tagged(task: t.to_s) do
      clazz.each do |arg|
        clazz.new.add(arg).done!
      end
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
multitask all: ['entsoe:all', 'aemo:all', 'ieso:all', 'eia:all', :ercot, 'caiso:all', 'elexon:all', :nationalgrideso, :ree, 'aeso:all', :hydroquebec, :tohoku, 'eskom:all', :ons, 'cammesa:all', :taipower]
namespace :ieso do
  desc "Run refresh tasks"
  task all: [:unit, :load, :price, :intertie]
  loop_task :unit, Ieso::Unit
  loop_task :load, Ieso::Load
  loop_task :price, Ieso::Price
  loop_task :intertie, Ieso::Intertie
end

namespace :eia do
  desc "Run refresh tasks"
  task all: [:generation, :load, :interchange]
  loop_task :generation, Eia::Generation
  loop_task :load, Eia::Load
  loop_task :interchange, Eia::Interchange
end

oneshot_task :ercot, Ercot::Generation

namespace :caiso do
  desc "Run refresh tasks"
  task all: [:fuelsource, :load]
  chain_task :fuelsource, Caiso::FuelSource
  chain_task :load, Caiso::Load
end

namespace :elexon do
  desc "Run refresh tasks"
  task all: [:fuelinst, :load, :unit]
  loop_task :fuelinst, Elexon::Fuelinst
  loop_task :load, Elexon::Load
  loop_task :unit, Elexon::Unit
  loop_task :generation, Elexon::Generation
end

loop_task :nationalgrideso, NationalGridEso::DemandLive

namespace :entsoe do
  desc "Run refresh tasks"
  task all: [:generation, :unit, :load, :price, :transmission]
  loop_task :generation, EntsoeFms::Generation
  loop_task :unit, EntsoeFms::Unit
  loop_task :load, EntsoeFms::Load
  loop_task :price, EntsoeFms::Price
  loop_task :price_api, EntsoeApi::Price
  loop_task :transmission, EntsoeFms::Transmission
end

namespace :aemo do
  desc "Run refresh tasks"
  task all: ['nem:all', 'wem:all']
  namespace :nem do
    desc "Run refresh tasks"
    task all: [:trading, :dispatch, :scada, :rooftoppv, :causer_pays]
    chain_task :trading, AemoNem::Trading
    chain_task :dispatch, AemoNem::Dispatch
    chain_task :scada, AemoNem::Scada
    chain_task :rooftoppv, AemoNem::RooftopPv
    chain_task :causer_pays, AemoNem::CauserPays
  end
  namespace :wem do
    desc "Run refresh tasks"
    task all: [:balancing, :scada, :scada_reform, :distributed_pv, :reference_trading_price, :operational_demand]
    chain_task :scada_reform, AemoWem::ScadaReform
    chain_task :reference_trading_price, AemoWem::ReferenceTradingPrice
    chain_task :operational_demand, AemoWem::OperationalDemand
    chain_task :scada, AemoWem::Scada
    chain_task :distributed_pv, AemoWem::DistributedPv
    #chain_task :balancing, AemoWem::Balancing
    oneshot_task :balancing, AemoWem::BalancingLive
  end
end

namespace :eskom do
  task all: [:generation, :demand]
  oneshot_task :generation, Eskom::Generation
  oneshot_task :demand, Eskom::Demand
end

loop_task :ree, Ree::Generation

desc "Run refresh tasks"
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

loop_task :tohoku, Tohoku::Juyo
desc 'Refresh ONS'
task(:ons) { Ons.refresh }
desc 'Refresh Taipower'
task(:taipower) { Taipower::Generation.refresh }
namespace :aeso do
  task all: [:generation, :price]
  desc 'Refresh AESO'
  task(:generation) { Aeso::Generation.refresh }
  chain_task :price, Aeso::Price
end


namespace :cammesa do
  task all: [:renovables, :programacion_diaria]
  loop_task :renovables, Cammesa::Renovables
  loop_task :programacion_diaria, Cammesa::ProgramacionDiaria
end

desc 'Export areas to test/fixtures/areas.yml'
task :fixtures_areas do
  File.open("test/fixtures/areas.yml", 'w') do |f|
    Area.order(:source, :code).all.each do |a|
      f.write({"#{a.source}_#{a.code}" => a.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end

desc 'Export areas to test/fixtures/locations.yml'
task :fixtures_locations do
  File.open("test/fixtures/locations.yml", 'w') do |f|
    Location.order(:name).all.each do |l|
      f.write({"#{l.name}" => l.attributes }.
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


desc 'Export areas areas to test/fixtures/areas_areas.yml'
task :fixtures_aa do
  File.open("test/fixtures/areas_areas.yml", 'w') do |f|
    AreasArea.order(:from_area_id, :to_area_id).all.each do |aa|
      f.write({"#{aa.from_area.source}_#{aa.from_area.code}_#{aa.to_area.source}_#{aa.to_area.code}" => aa.attributes }.
               to_yaml.sub!(/---\s?/, ""))
    end
  end
end
