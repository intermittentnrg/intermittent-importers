ENV['TZ'] = 'UTC'

require 'bundler/setup'
require 'dotenv'

envfile = ".env-#{ENV['ENV']}"
if ENV['ENV'] && File.exist?(envfile)
  Dotenv.load envfile
else
  Dotenv.load
end

require 'rails'
require 'semantic_logger'
SemanticLogger.default_level = :info
SemanticLogger.application = Rails.env.to_s
SemanticLogger.environment = Rails.env.to_s
if !Rails.env.test?
  SemanticLogger.add_appender(
    appender:    :elasticsearch,
    url:         ENV['ES_URL'],
    index:       "intermittency",
    data_stream: true
  )
end
SemanticLogger.add_appender(io: $stderr, formatter: :color)

require 'date'
require 'active_support'
require 'active_support/core_ext'

require "zeitwerk"
loader = Zeitwerk::Loader.new
#loader.push_dir(...)
loader.push_dir("#{__dir__}")
loader.push_dir("#{__dir__}/../app/models")
loader.ignore("#{__dir__}/activerecord-connect.rb")
loader.setup # ready!
#require 'pry' ; binding.pry
