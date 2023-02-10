# frozen_string_literal: true

module BeyondCanvas
  class Configuration
    include AssetRegistration
    include MenuItemRegistration
    include WebhookEventRegistration

    ATTRIBUTES = [:client_credentials, :cockpit_app, :custom_styles, :debug_mode, :encryption_deterministic_key,
                  :encryption_key_derivation_salt, :encryption_primary_key, :email_logo, :favicon, :open_app_url,
                  :site_logo, :site_title, :webhook_site_url, :model_errors_joined_by].freeze

    attr_accessor(*ATTRIBUTES)

    def initialize
      @client_credentials             = false
      @cockpit_app                    = false
      @custom_styles                  = false
      @debug_mode                     = false
      @encryption_deterministic_key   = nil
      @encryption_key_derivation_salt = nil
      @encryption_primary_key         = nil
      @email_logo                     = nil
      @favicon                        = nil
      @open_app_url                   = nil
      @site_logo                      = nil
      @site_title                     = ::Rails.application.class.name.split('::').first.humanize
      @webhook_site_url               = nil
      @model_errors_joined_by         = ','
    end

    def client_credentials?
      @client_credentials && !::Rails.env.production?
    end

    def custom_styles?
      @cockpit_app || @custom_styles
    end

    def subscribe_to_beyond_webhooks?
      !::Rails.env.development? || @webhook_site_url
    end

    def setup!
      register_default_assets
      register_default_webhook_events
    end

    private

    def register_default_assets
      register_stylesheet 'beyond_canvas/base.css', 'data-turbo-track': 'reload'
    end

    def register_default_webhook_events
      register_webhook_event('app.deleted')
      register_webhook_event('app.uninstalled')
    end
  end
end
