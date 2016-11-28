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
