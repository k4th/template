# frozen_string_literal: true

module BeyondCanvas
  module Setup
    delegate(*Configuration::ATTRIBUTES, :stylesheets, :webhook_events, :menu_items,
             :client_credentials?, :custom_styles?, :subscribe_to_beyond_webhooks?, to: :configuration)

    def configuration
      @configuration ||= Configuration.new
    end

    def setup
      configuration.setup!

      yield configuration
    end
  end
end
