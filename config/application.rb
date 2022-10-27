# frozen_string_literal: true

# defines the application base configutation
require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Tom
  class Application < Rails::Application
    config = if ENV['RACK_ENV'] == 'test'
               {
                 'testing' => true,
                 'sentry' => '',
                 'github' => {
                   'client_id' => '--the-token--',
                   'client_secret' => '?',
                   'encryption_secret' => '?',
                   'login' => '0capa',
                   'token' => '--the-token--'
                 },
                 'pgsql' => {
                   'user' => 'postgres',
                   'password' => '1234',
                   'url' => "jdbc:postgresql://pgsql.0capa.com:5432/capa?user=capa",
                 },
                 'id_rsa' => ''
               }
             else
               config = YAML.safe_load(File.open(File.join(File.dirname(__FILE__), 'config.yml')))
               raise 'Missing configuration file config.yml' if config.nil?
               config
             end
    set :config, config
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    config.api_only = true
    config.autoloader = :classic
  end
end
