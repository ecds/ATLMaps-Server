source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2'
gem 'bootsnap'
# Use postgres with the postgis plugin as the database for Active Record
gem 'activerecord-postgis-adapter'
gem 'pg'
# gem 'squeel'
gem 'acts-as-taggable-on'
gem 'pg_search'
gem 'rgeo'
gem 'rgeo-activerecord', git: 'git://github.com/jayvarner/rgeo-activerecord.git', branch: 'develop'
gem 'rgeo-geojson'
gem 'roo'

# API Responses
gem 'active_model_serializers', '~> 0.10.0.rc3'
gem 'kaminari' # For pagination

# Authentication
# gem 'rails_api_auth'
gem 'cancan'
gem 'rails_api_auth', git: 'git://github.com/jayvarner/rails_api_auth.git', tag: '0.0.9'

gem 'json'
gem 'rack-cors', require: 'rack/cors'
# gem 'rest-client'
# gem 'turbolinks'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'yard', group: :doc

# Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
gem 'spring', group: :development
gem 'web-console', group: :development
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
gem 'capistrano-passenger', group: :development
gem 'capistrano-rails', group: :development
gem 'capistrano-rbenv', group: :development

gem 'httparty'
gem 'nokogiri'

# Use debugger
gem 'byebug', group: %i[development test]

# For file uploads
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

group :development do
    gem 'puma'
    gem 'seed_dump'
    gem 'listen'
end

# for testing
group :development, :test do
    gem 'bundler-audit'
    gem 'rspec-rails'
end

group :test do
    gem 'coveralls', require: false
    gem 'database_cleaner'
    gem 'factory_bot_rails'
    gem 'faker', git: 'git://github.com/stympy/faker.git', branch: 'master'
    gem 'shoulda-matchers'
    gem 'simplecov'
end
