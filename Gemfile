source "https://rubygems.org"

ruby "2.2.3"
gem "rails", "4.2.5"
gem "rails-api"
gem "faraday"
gem "figaro"
gem "jwt"
gem 'rack-cors', require: 'rack/cors'
gem 'active_model_serializers', '~> 0.10.0'
gem "cancancan", "~> 1.10"
gem "faker"
gem 'globalize', '~> 5.0.0'

group :production do
  gem "rails_12factor"
  gem "pg"
end

group :development, :test do
  gem "pry-rails"
  gem "spring"
  gem "sqlite3"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "shoulda-matchers", "~> 3.1"
  gem "simplecov"
  gem "coveralls", require: false
  gem "vcr"
  gem "webmock"
end
