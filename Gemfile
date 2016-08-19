source "https://rubygems.org"

ruby "2.2.3"
gem "rails", "4.2.5"
gem "rails-api"
gem "faraday"
gem "figaro"
gem "jwt"
gem "active_model_serializers"
gem "doorkeeper"
gem "doorkeeper-jwt"

group :production do
  gem "rails_12factor"
  gem "pg"
end

group :development, :test do
  gem "pry"
  gem "spring"
  gem "sqlite3"
  gem "rspec-rails"
  gem "factory_girl_rails"
  gem "database_cleaner"
  gem "shoulda-matchers", "~> 3.1"
  gem "simplecov"
  gem "coveralls", require: false
  gem "faker"
  gem "vcr"
  gem "webmock"
end
# To use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano', :group => :development

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
