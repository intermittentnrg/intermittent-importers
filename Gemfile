source 'https://rubygems.org'

ruby "3.4.7"

gem "rails", "~> 7.1.5", ">= 7.1.5.1"

# Use the Puma web server [https://github.com/puma/puma]
gem "puma", ">= 5.0"

# Use Kredis to get higher-level data types in Redis [https://github.com/rails/kredis]
# gem "kredis"

# Use Active Model has_secure_password [https://guides.rubyonrails.org/active_model_basics.html#securepassword]
# gem "bcrypt", "~> 3.1.7"

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", require: false

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem "debug", platforms: %i[ mri windows ]
end

group :development do
  # Use console on exceptions pages [https://github.com/rails/web-console]
  gem "web-console"

  # Add speed badges [https://github.com/MiniProfiler/rack-mini-profiler]
  # gem "rack-mini-profiler"

  # Speed up commands on slow machines / big apps [https://github.com/rails/spring]
  # gem "spring"
end

group :test do
  # Use system testing [https://guides.rubyonrails.org/testing.html#system-testing]
  gem "capybara"
  #gem "selenium-webdriver"
end

gem 'pry'
# Network protocols
gem 'faraday'
gem 'faraday-net_http_persistent', '~> 2.0'
gem 'faraday-gzip'
gem 'faraday-follow_redirects'
gem 'faraday-retry'
gem 'faraday-http-cache'

gem 'net-sftp'
gem 'aws-sdk-sqs'

gem 'zeitwerk'
gem 'activesupport'
gem 'dotenv-rails'
gem 'rake'

gem 'semantic_logger'
gem 'elasticsearch'

gem 'octokit'

# Parsers
gem 'chronic'
gem 'business_time'
gem 'csv'
gem 'fastest_csv', git: 'https://github.com/custora/fastest-csv.git', tag: 'v0.8.2'
gem 'fast_jsonparser'
gem 'ox'
gem 'rubyzip'

#Misc
#gem 'peach'

# Database
gem 'activerecord', '~> 7.1.0'
gem 'pg'
gem 'database_cleaner-active_record'
gem 'timescaledb'

gem 'pgsync'

# Tweet screenshot
gem 'selenium-webdriver'
gem "x", "~> 0.14.1"
gem 'minisky', '~> 0.5.0'

group :test do
  gem 'rspec'
  gem 'rspec-collection_matchers'
  gem 'rspec_junit_formatter'
  gem 'simplecov', require: false
  gem 'simplecov-cobertura', require: false
  gem 'timecop'
  gem 'vcr'
  gem 'webmock'
end

gem "roo", "~> 2.10"
gem 'rtesseract', '~> 3.1'
gem 'faraday-cookie_jar', '~> 0.0.8'
