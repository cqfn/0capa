# frozen_string_literal: true

# defines the application base configutation
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tom
  class Application < Rails::Application
    config.load_defaults 6.1
    config.api_only = true
    config.autoloader = :classic
    config.hosts << '0capa.ru'
    config.middleware.use ActionDispatch::Cookies
  end
end
