# frozen_string_literal: true

# Root for ActiveStorage URLs
Rails.application.default_url_options[:host] = ENV['ROOT_URL']

# The urls that ActiveStorage expire 5 mins later by default.
# This setting helps avoid issues when the server's time might be a little off.
Rails.application.config.active_storage.service_urls_expire_in = 1.hour
