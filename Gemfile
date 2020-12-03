# frozen_string_literal: true

source('https://rubygems.org')

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem('bootsnap')
# RAILS!
gem('rails', '~> 6.0')
# Use postgres with the postgis plugin as the database for Active Record
gem('activerecord-postgis-adapter', '~> 6.0.0')
# Postgres
gem('pg')
# gem 'squeel'
gem('acts-as-taggable-on')
# PgSearch builds named scopes that take advantage of
# PostgreSQL's full text search
# https://github.com/Casecommons/pg_search
gem('pg_search')

# RGeo is a geospatial data library for Ruby.
# https://github.com/rgeo/rgeo
gem('rgeo')

# PostGIS supportRGeo::ActiveRecord is an optional RGeo
# module providing spatial extensions for ActiveRecord,
# as well as a set of helpers for writing spatial
# ActiveRecord adapters based on RGeo.
# https://github.com/rgeo/rgeo-activerecord
gem('rgeo-activerecord')

# Extension to RGeo that provides GeoJSON encoding and decoding.
# https://github.com/rgeo/rgeo-geojson
gem('rgeo-geojson')

# proj.4 extensions to the rgeo gem.
# PROJ is a generic coordinate transformation software that
# transforms geospatial coordinates from one coordinate
# reference system (CRS) to another.
# https://github.com/rgeo/rgeo-proj4
# https://proj.org/
gem('rgeo-proj4')

# Extension to  RGeo for reading geospatial data from ESRI shapefiles.
# https://github.com/rgeo/rgeo-shapfile
gem('rgeo-shapefile')

# ActiveModelSerializers brings convention over configuration to your JSON generation.
# https://github.com/rails-api/active_model_serializers/tree/0-10-stable
gem('active_model_serializers', '~> 0.10.0')

# For pagination
gem('kaminari')

# Authentication
# gem 'rails_api_auth'
gem('cancan')
# The ECDS Auth Engine
gem 'ecds_rails_auth_engine', git: 'git://github.com/ecds/ecds_rails_auth_engine.git', branch: 'feature/fauxoauth'
# gem('ecds_rails_auth_engine', path: '/data/ecds_auth_engine')

# JSON
gem('json')

# Zip Files
gem('rubyzip')

# Ruby interface for spreadsheets
gem('roo')

# Adds CORS headers
gem('rack-cors', require: 'rack/cors')

# Ain't no party like a httparty, because a httparty don't stop.
gem('httparty')
# HTML, XML, SAX, and Reader parser.
gem('nokogiri')

# For file uploads
# S3 support for ActiveStorage
gem('aws-sdk-s3', require: false)
# Resize/crop images
gem('mini_magick')

group :development do
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem('spring')
  # Devlopment server
  gem('puma')
  # bundle exec rake doc:rails generates the API under doc/api.
  gem('yard', group: :doc)

  # Deployment
  # Adds a task to restart your application after deployment
  gem('capistrano-passenger')
  # Rails specific tasks
  gem('capistrano-rails')
  # Idiomatic rbenv support
  gem('capistrano-rbenv')
end

# for testing
group :development, :test do
  # Check for vulnerable versions of gems and other security concerns
  gem('bundler-audit')
  # RSpec testing framework for Rails
  gem('rspec-rails')
  # Library for stubbing and setting expectations on HTTP requests
  gem('webmock')
end

group :test do
  # Generate test coverage reports
  gem('coveralls', require: false)
  # Strategies for cleaning database before, during, and after tests
  gem('database_cleaner')
  # Generate model objects
  gem('factory_bot_rails')
  # Populate test objects with fake data.
  gem('faker')
  # rovides RSpect-compatible one-liners to test common Rails functionality
  gem('shoulda-matchers')
end
