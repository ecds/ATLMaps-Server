# frozen_string_literal: true

require_relative('boot')

require('rails/all')

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Atlmaps
  class Application < Rails::Application
    VERSION = '1.0.0'
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults(5.0)
    config.action_controller.include_all_helpers = false
    config.middleware.use(ActionDispatch::Cookies)
    config.middleware.use(ActionDispatch::Session::CookieStore)
    config.api_only = true

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
