ENV['TZ'] = 'UTC'

require 'bundler/setup'
require 'dotenv/load'

require 'semantic_logger'
SemanticLogger.default_level = :info
if ENV['CI']
  SemanticLogger.add_appender(io: $stderr, formatter: :json)
else
  SemanticLogger.add_appender(io: $stderr, formatter: :color)
end

require 'date'
require 'active_support'
require 'active_support/core_ext'

$LOAD_PATH.unshift File.dirname(__FILE__)
$LOAD_PATH.unshift(File.expand_path(File.dirname(__FILE__)+'/../app/models'))

def Object.const_missing(name)
  @looked_for ||= {}
  str_name = name.to_s
  return @looked_for[str_name] if @looked_for[str_name].is_a? Class
  raise "Class not found: #{name}" if @looked_for[str_name]
  file = str_name.underscore
  require file
  @looked_for[str_name] = klass = const_get(name)
  return klass if klass
  raise "Class not found: #{name}"
end
