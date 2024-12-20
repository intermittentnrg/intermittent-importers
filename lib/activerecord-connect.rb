require 'erb'
require 'active_record'

ActiveRecord::Base.configurations = YAML.unsafe_load(ERB.new(File.read('db/config.yml')).result)
ActiveRecord::Base.establish_connection(Rails.env.to_sym)
ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz
unless Rails.env.test?
  ActiveRecord::ConnectionAdapters::AbstractAdapter.set_callback :checkout, :after do |conn|
    conn.exec_query "SET timescaledb.max_tuples_decompressed_per_dml_transaction TO 1000000"
  end
end

ActiveSupport.on_load(:active_record) { extend Timescaledb::ActsAsHypertable }

#ActiveRecord::Base.logger = SemanticLogger::Logger.new(STDOUT)
#ActiveRecord::Base.logger = Logger.new(STDOUT)
