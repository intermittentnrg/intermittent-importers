require 'erb'
require 'active_record'

ActiveRecord::Base.configurations = YAML.unsafe_load(ERB.new(File.read('db/config.yml')).result)
ActiveRecord::Base.establish_connection(:development)
ActiveRecord::Base.connection.enable_query_cache!
