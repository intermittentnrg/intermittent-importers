require 'rubygems'
require 'rspec'
require 'rspec/collection_matchers'
require 'webmock/rspec'
require 'vcr'

ENV['ENV']='test'
ENV['RAILS_ENV']='test'
require './lib/init'
require './lib/activerecord-connect'

if ENV.fetch('COVERAGE', false)
  require 'simplecov'
  require 'simplecov-cobertura'
  SimpleCov.start
  SimpleCov.formatter = SimpleCov::Formatter::CoberturaFormatter
end

SemanticLogger.default_level = :warn

ENV['ENTSOE_TOKEN'] ||= 'DUMMYTOKEN'
VCR.configure do |config|
  config.cassette_library_dir = "fixtures/vcr_cassettes"
  config.hook_into :webmock
  config.ignore_hosts ENV['ES_HOST']
  config.filter_sensitive_data('<TOKEN>') { ENV['ENTSOE_TOKEN'] }
  config.filter_sensitive_data('<EIA_TOKEN>') { ENV['EIA_TOKEN'] }
  config.filter_sensitive_data('<ELEXON_TOKEN>') { ENV['ELEXON_TOKEN'] }
  config.filter_sensitive_data('<AESO_PRIMARY_KEY>') { ENV['AESO_PRIMARY_KEY'] }
end

Dir["./spec/support/**/*.rb"].each { |f| require f }

require 'database_cleaner/active_record'
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.strategy = :transaction
    #DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
  config.include Helpers::ZipFile
end
