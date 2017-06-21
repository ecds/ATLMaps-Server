source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0'
# Use postgres with the postgis plugin as the database for Active Record
gem 'pg'
gem 'activerecord-postgis-adapter', '~> 5.0'
# gem 'squeel'
gem 'rgeo-geojson'
gem 'rgeo', '~> 0.6.0'
gem 'pg_search'
gem 'acts-as-taggable-on', '~> 5.0'

# API Responses
gem 'active_model_serializers', '~> 0.10.0.rc3'
gem 'kaminari' # For pagination

# Authentication
# gem 'rails_api_auth'
gem 'rails_api_auth', :git => 'git://github.com/jayvarner/rails_api_auth.git', :tag => '0.0.9'
gem 'cancan'

gem 'json'
gem 'rest-client'
gem 'rack-cors', :require => 'rack/cors'
gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development
gem 'web-console', '~> 2.0', group: :development
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'


gem 'httparty'
gem 'nokogiri'

# gem 'ci_reporter'
gem 'simplecov' # , group: :test
gem 'coveralls', require: false
# Use debugger
gem 'byebug', group: [:development, :test]

# For file uploads
gem 'carrierwave'
gem 'fog', '~> 1.38.0'
gem 'mini_magick'

group :development do
    # Use Capistrano for deployment
    gem 'capistrano-rails'
    gem 'capistrano-passenger'
    gem 'capistrano-rbenv', '~> 2.0'
    gem 'yard'

end

# for testing
group :development, :test do
  gem 'rspec-rails', '~> 3.5'
end

group :test do
  gem 'factory_girl_rails', '~> 4.0'
  gem 'shoulda-matchers', '~> 3.1'
  gem 'faker'
  gem 'database_cleaner'
end
