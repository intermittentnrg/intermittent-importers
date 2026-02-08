# frozen_string_literal: true

require 'English'
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
    conn.exec_query 'SET timescaledb.max_tuples_decompressed_per_dml_transaction TO 1000000'
  end
end
# ActiveRecord::Base.logger = Logger.new(STDOUT)

ActiveSupport.on_load(:active_record) { extend Timescaledb::ActsAsHypertable }

def chain_task(name, clazz)
  desc 'Run refresh task with chaining API'
  task name do |t|
    SemanticLogger.tagged(task: t.to_s) do
      clazz.each do |arg|
        clazz.new.add(arg).done!
      end
    rescue StandardError
      @logger.error 'Exception', $ERROR_INFO
    end
  end
end

def refresh_task(name, clazz)
  desc 'Run refresh task'
  task name do |t|
    SemanticLogger.tagged(task: t.to_s) do
      clazz.refresh
    rescue StandardError
      @logger.error 'Exception', $ERROR_INFO
    end
  end
end

def oneshot_chain_task(name, clazz)
  desc 'Run refresh task'
  task name do |t|
    SemanticLogger.tagged(task: t.to_s) do
      clazz.new.add.done!
    rescue StandardError
      @logger.error 'Exception', $ERROR_INFO
    end
  end
end

task :ping do |t|
  SemanticLogger.tagged(task: t.to_s) { logger.info 'ping' }
end

desc 'Run all refresh tasks'
multitask all: ['entsoe:all', 'aemo:all', 'ieso:all', 'eia:all', :ercot, 'caiso:all', 'elexon:all', :nationalgrideso,
                :ree, 'aeso:all', :hydroquebec, 'japan_juyo:all', 'japan_nuclear:all', :kpx, 'eskom:all', :ons, 'cammesa:all', :taipower]
namespace :ieso do
  desc 'Run refresh tasks'
  task all: %i[unit load price intertie]
  chain_task :unit, Ieso::Unit
  chain_task :load, Ieso::Load
  chain_task :price, Ieso::Price
  chain_task :intertie, Ieso::Intertie
end

namespace :eia do
  desc 'Run refresh tasks'
  task all: %i[generation load interchange]
  chain_task :generation, Eia::Generation
  chain_task :load, Eia::Load
  chain_task :interchange, Eia::Interchange
end

oneshot_chain_task :ercot, Ercot::Generation

namespace :caiso do
  desc 'Run refresh tasks'
  task all: %i[fuelsource load]
  chain_task :fuelsource, Caiso::FuelSource
  chain_task :load, Caiso::Load
end

namespace :elexon do
  desc 'Run refresh tasks'
  task all: %i[fuelinst load unit]
  chain_task :fuelinst, Elexon::Fuelinst
  chain_task :load, Elexon::Load
  chain_task :unit, Elexon::Unit
  chain_task :generation, Elexon::Generation
end

chain_task :nationalgrideso, NationalGridEso::DemandLive

namespace :entsoe do
  desc 'Run refresh tasks'
  task all: %i[generation unit load price transmission]
  refresh_task :generation, EntsoeFms::Generation
  refresh_task :unit, EntsoeFms::Unit
  refresh_task :load, EntsoeFms::Load
  refresh_task :price, EntsoeFms::Price
  chain_task :price_api, EntsoeApi::Price
  refresh_task :transmission, EntsoeFms::Transmission
end

namespace :aemo do
  desc 'Run refresh tasks'
  task all: ['nem:all', 'wem:all']
  namespace :nem do
    desc 'Run refresh tasks'
    task all: %i[trading dispatch scada rooftoppv causer_pays]
    chain_task :trading, AemoNem::Trading
    chain_task :dispatch, AemoNem::Dispatch
    chain_task :scada, AemoNem::Scada
    chain_task :rooftoppv, AemoNem::RooftopPv
    chain_task :causer_pays, AemoNem::CauserPays
  end
  namespace :wem do
    desc 'Run refresh tasks'
    task all: %i[balancing scada scada_reform distributed_pv reference_trading_price operational_demand]
    chain_task :scada_reform, AemoWem::ScadaReform
    chain_task :reference_trading_price, AemoWem::ReferenceTradingPrice
    chain_task :operational_demand, AemoWem::OperationalDemand
    chain_task :scada, AemoWem::Scada
    chain_task :distributed_pv, AemoWem::DistributedPv
    # chain_task :balancing, AemoWem::Balancing
    refresh_task :balancing, AemoWem::BalancingLive
  end
end

namespace :eskom do
  task all: %i[generation demand]
  oneshot_chain_task :generation, Eskom::Generation
  oneshot_chain_task :demand, Eskom::Demand
end

chain_task :ree, Ree::Generation

oneshot_chain_task :hydroquebec, HydroQuebec::Generation

# task :nspower do
#   Nspower::Combined.new.process
# rescue
#   logger.error "Exception", $!
# end

namespace :japan_juyo do
  task all: %i[tohoku hepco rikuden okiden chugoku kyuden tepco chuden yonden kepco]
  chain_task :tohoku, JapanJuyo::Tohoku
  chain_task :hepco, JapanJuyo::Hepco
  chain_task :rikuden, JapanJuyo::Rikuden
  chain_task :okiden, JapanJuyo::Okiden
  chain_task :chugoku, JapanJuyo::Chugoku
  chain_task :kyuden, JapanJuyo::Kyuden
  oneshot_chain_task :tepco, JapanJuyo::Tepco
  oneshot_chain_task :chuden, JapanJuyo::Chuden
  oneshot_chain_task :yonden, JapanJuyo::Yonden
  oneshot_chain_task :kepco, JapanJuyo::Kepco
end

namespace :japan_nuclear do
  task all: %i[kepco kyuden yonden]
  oneshot_chain_task :kepco, JapanNuclear::Kepco
  oneshot_chain_task :kyuden, JapanNuclear::Kyuden
  oneshot_chain_task :yonden, JapanNuclear::Yonden
end

oneshot_chain_task :kpx, Kpx::Generation

refresh_task :ons, Ons
refresh_task :taipower, Taipower::Generation
namespace :aeso do
  task all: %i[generation price]
  refresh_task :generation, Aeso::Generation
  chain_task :price, Aeso::Price
end

namespace :cammesa do
  task all: %i[renovables programacion_diaria]
  chain_task :renovables, Cammesa::Renovables
  chain_task :programacion_diaria, Cammesa::ProgramacionDiaria
end

desc 'Export areas to test/fixtures/areas.yml'
task :fixtures_areas do
  File.open('test/fixtures/areas.yml', 'w') do |f|
    Area.order(:source, :code).all.each do |a|
      f.write({ "#{a.source}_#{a.code}" => a.attributes }
               .to_yaml.sub!(/---\s?/, ''))
    end
  end
end

desc 'Export areas to test/fixtures/locations.yml'
task :fixtures_locations do
  File.open('test/fixtures/locations.yml', 'w') do |f|
    Location.order(:name).all.each do |l|
      f.write({ l.name.to_s => l.attributes }
               .to_yaml.sub!(/---\s?/, ''))
    end
  end
end

desc 'Export production types to test/fixtures/production_types.yml'
task :fixtures_pt do
  File.open('test/fixtures/production_types.yml', 'w') do |f|
    ProductionType.order(:name).all.each do |pt|
      f.write({ pt.name.to_s => pt.attributes }
               .to_yaml.sub!(/---\s?/, ''))
    end
  end
end

desc 'Export area production types to test/fixtures/areas_production_types.yml'
task :fixtures_apt do
  File.open('test/fixtures/areas_production_types.yml', 'w') do |f|
    AreasProductionType.order(:area_id, :production_type_id).all.each do |apt|
      f.write({ "#{apt.area.code}_#{apt.production_type.name}" => apt.attributes }
               .to_yaml.sub!(/---\s?/, ''))
    end
  end
end

desc 'Export areas areas to test/fixtures/areas_areas.yml'
task :fixtures_aa do
  File.open('test/fixtures/areas_areas.yml', 'w') do |f|
    AreasArea.order(:from_area_id, :to_area_id).all.each do |aa|
      f.write({ "#{aa.from_area.source}_#{aa.from_area.code}_#{aa.to_area.source}_#{aa.to_area.code}" => aa.attributes }
               .to_yaml.sub!(/---\s?/, ''))
    end
  end
end
