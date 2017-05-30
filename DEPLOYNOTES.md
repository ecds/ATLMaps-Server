# Deploynotes
The deployment is managed by Capistrano.

Global depoly settings are found in `Capfile`. Staging and Productions settings are found in `config/deploy`.

## Deploy to Staging
`cap deploy staging`

## Deploy to Productions
`cap deploy production`
In `config/initializers/assets.rb` there is a the line to compile the rails_admin assets for production:

`Rails.application.config.assets.precompile += %w( rails_admin/rails_admin.css
rails_admin/rails_admin.js )`

## Server Setup
https://www.digitalocean.com/community/tutorials/how-to-install-ruby-on-rails-with-rbenv-on-ubuntu-16-04
http://www.gis-blog.com/how-to-install-postgis-2-3-on-ubuntu-16-04-lts/
