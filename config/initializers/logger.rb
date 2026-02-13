require 'semantic_logger'
SemanticLogger.default_level = :info
SemanticLogger.application = Rails.env.to_s
SemanticLogger.environment = Rails.env.to_s
SemanticLogger.add_appender(io: $stderr, formatter: :color)

case Rails.env
when 'cloud'
  SemanticLogger.add_appender(
    appender: :http,
    url:      ENV['ES_URL'],
    read_timeout: 60
  )
when 'test'
  SemanticLogger.default_level = :warn
  # nothing
else
  SemanticLogger.add_appender(
    appender:    :elasticsearch,
    url:         ENV['ES_URL'],
    index:       "intermittency",
    data_stream: true
  )
end
