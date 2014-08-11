require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trybe
  class Application < Rails::Application
    config.event_tracker.mixpanel_key = "3b3f80e302d5dac475ea95f63b5fce12"
        config.event_tracker.google_analytics_key = "UA-13042465-5"
  end
end
