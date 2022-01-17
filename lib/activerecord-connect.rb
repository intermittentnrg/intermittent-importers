require 'erb'
require 'active_record'

ActiveRecord::Base.configurations = YAML.load(ERB.new(File.read('config/database.yaml')).result)
ActiveRecord::Base.establish_connection(:development)
