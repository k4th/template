# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
require 'beyond_canvas'

module Dummy
  class Application < Rails::Application
    # Beyond Canvas uses Rails 7's Active Record Encryption to encrypt the
    # `beyond_access_token` and the `beyond_refresh_token`.
    #
    # These keys are needed to make it work. Store them safely on environment
    # variables or using the Rails Encrypted Credentials:
    #
    config.active_record.encryption.primary_key         = ENV.fetch('ENCRYPTION_PRIMARY_KEY')
    config.active_record.encryption.deterministic_key   = ENV.fetch('ENCRYPTION_DETERMINISTIC_KEY')
    config.active_record.encryption.key_derivation_salt = ENV.fetch('ENCRYPTION_KEY_DERIVATION_SALT')

    config.load_defaults Rails::VERSION::STRING.to_f

    # For compatibility with applications that use this config
    # config.action_controller.include_all_helpers = false

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.view_component.default_preview_layout = 'previews/application'
  end
end
