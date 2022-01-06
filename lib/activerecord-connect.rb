require 'active_record'
require './app/models/entsoe_generation'

db_config_file = File.open('config/database.yaml')
db_config = YAML::load(db_config_file)['development']
puts db_config

ActiveRecord::Base.establish_connection(db_config)
