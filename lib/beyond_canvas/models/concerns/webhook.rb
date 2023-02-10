# frozen_string_literal: true

module BeyondCanvas
  module Models
    module Concerns
      module Webhook
        extend ActiveSupport::Concern

        included do
          # Attribute accessor to generate webhook url
          attr_accessor :http_host

          ##############################################################################
          # Encrypted attribute configuration
          ##############################################################################
          encrypts :beyond_shared_secret
        end

        ##############################################################################
        # Instance methods
        ##############################################################################

        #
        # Subscribes to Beyond webhooks:
        #   * Callback URI: {APP_URL}/shops/:id/beyond_webhook
        #
        def subscribe_to_beyond_webhooks
          return unless BeyondCanvas.subscribe_to_beyond_webhooks?

          refresh_token_if_needed!
          # Unsubscribe from all existing Beyond webhooks
          unsubscribe_from_all_beyond_webhooks
          # Create and save a signer
          create_signer
          # Subscribe to webhooks
          to_session.webhook_subscriptions.create(callback_uri: beyond_webhooks_url,
                                                  event_types: webhooks_event_types)
        end

        #
        # Unsubscribe from Beyond webhooks
        #
        def unsubscribe_from_all_beyond_webhooks
          refresh_token_if_needed!

          session = to_session

          session.webhook_subscriptions.all.dig(:embedded, :subscriptions)&.each do |webhook|
            session.webhook_subscriptions.delete(webhook[:id])
          end
        end

        #
        # Update suscription from Beyond webhooks
        #
        def update_suscription_of_beyond_webhooks(callback_uri = beyond_webhooks_url)
          refresh_token_if_needed!

          session = to_session

          session.webhook_subscriptions.all.dig(:embedded, :subscriptions)&.each do |webhook|
            session.webhook_subscriptions.update(webhook[:id], callback_uri:, event_types: webhooks_event_types)
          end
        end

        private

        #
        # Deletes all existing signers and creates and stores a new one
        #
        def create_signer
          # Get all existing signer ids
          signer_ids = to_session.signers.all.dig(:embedded, :signers)&.map { |e| e[:id] }
          # Remove the first signer if max number of signers reached to allow to create a new one
          to_session.signers.delete(signer_ids.slice!(0)) if signer_ids&.count == 5

          # Create and save the new signer
          signer = to_session.signers.create
          update(beyond_shared_secret: signer[:shared_secret])
          # Delete old signers
          signer_ids&.each { |signer_id| to_session.signers.delete(signer_id) }
        end

        #
        # Generates the Beyond webhook url for a given shop_id. If Rails.env is development, it uses the
        # WEBHOOK_SITE_URL environment variable. In any other case, it uses the request.env['HTTP_HOST'], that should be
        # {APP_URL}/shops/:id/beyond_webhook
        #
        def beyond_webhooks_url
          if Rails.env.development?
            BeyondCanvas.webhook_site_url
          else
            Rails.application.routes.url_helpers.beyond_webhooks_shop_url(id,
                                                                          host: http_host || ENV.fetch('HTTP_HOST'),
                                                                          protocol: 'https')
          end
        end

        def webhooks_event_types
          BeyondCanvas.webhook_events.to_a
        end
      end
    end
  end
end
