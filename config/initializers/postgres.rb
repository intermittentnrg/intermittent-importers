ActiveRecord::ConnectionAdapters::PostgreSQLAdapter.datetime_type = :timestamptz

unless Rails.env.test?
  ActiveRecord::ConnectionAdapters::AbstractAdapter.set_callback :checkout, :after do |conn|
    conn.exec_query "SET timescaledb.max_tuples_decompressed_per_dml_transaction TO 1000000"
  end
end

ActiveSupport.on_load(:active_record) { extend Timescaledb::ActsAsHypertable }
