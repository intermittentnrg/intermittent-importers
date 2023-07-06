require './lib/init'
require './lib/activerecord-connect'

#require 'erb'
#require 'active_record'


db_dir = File.expand_path('../db', __FILE__)
config_dir = File.expand_path('../config', __FILE__)

include ActiveRecord::Tasks
DatabaseTasks.env = ENV['ENV'] || 'development'
DatabaseTasks.db_dir = db_dir
DatabaseTasks.database_configuration = YAML.load(ERB.new(File.read(File.join(config_dir, 'database.yaml'))).result)
DatabaseTasks.migrations_paths = File.join(db_dir, 'migrate')

task :environment do
  #ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.schema_format = :sql
  ActiveRecord::Base.dump_schema_after_migration = false
  #ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

load 'active_record/railties/databases.rake'

multitask all: ["ieso:all", "iea:all", "elexon:all", "entsoe:all", "opennem", "ree"]
namespace :ieso do
  task all: [:generation, :load]
  task :generation do
    Pump::Process.new(Ieso::Generation, Generation).run
  end
  task :load do
    Pump::Process.new(Ieso::Load, Load).run
  end
end

namespace :iea do
  task all: [:generation, :load]
  task :generation do
    Pump::Process.new(Eia::Generation, Generation).run
  end
  task :load do
    Pump::Process.new(Eia::Load, Load).run
  end
end

namespace :elexon do
  task all: [:generation, :load]
  task :generation do
    Pump::Process.new(Elexon::Generation, Generation).run
  end
  task :load do
    Pump::Process.new(Elexon::Load, Load).run
  end
end

namespace :entsoe do
  task all: [:generation, :load, :transmission, :price]
  task :generation do
    Pump::Process.new(ENTSOE::Generation, Generation).run
  end
  task :load do
    Pump::Process.new(ENTSOE::Load, Load).run
  end
  task :transmission do
    Pump::Process.new(ENTSOE::Transmission, Transmission).run
  end
  task :price do
    Pump::Process.new(ENTSOE::Price, Price).run
  end
end

task :opennem do
  Opennem::Latest.new.process
end

task :ree do
  Pump::Process.new(Ree::Generation, Generation).run
end
