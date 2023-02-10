# frozen_string_literal: true

require_dependency 'beyond_canvas/application_controller'

module BeyondCanvas
  module Controllers
    class BaseWebhookController < ::BeyondCanvas::ApplicationController
      skip_before_action :verify_authenticity_token

      include ::BeyondCanvas::RequestValidation
      include ::BeyondCanvas::StatusCodes

      before_action :set_shop, only: [:receive]

      if Rails.env.production?
        before_action only: [:receive] do
          signature = request.headers['x-epages-signature']
          bad_request unless valid_signature?(signature, signature_params, @shop.beyond_shared_secret)
        end
      end

      def receive
        begin
          if @shop
            body = JSON.parse(request.body.read)
            event = request.headers.env['HTTP_X_EPAGES_WEBHOOK_EVENT_TYPE'].gsub('.', '_')
            method = "handle_#{event}"
            send method, body
          end
        rescue JSON::ParserError
          render(json: { status: 400, error: 'Invalid payload' }) && (return)
        rescue NoMethodError
          render(json: { status: 500, message: 'https://github.com/ePages-de/beyond_canvas/wiki' }) && (return)
        end
        render json: { status: 200 }
      end

      private

      def handle_app_uninstalled(_data)
        @shop.unsubscribe_from_all_beyond_webhooks
        @shop.destroy
      end

      def handle_app_deleted(_data)
        @shop.unsubscribe_from_all_beyond_webhooks
        @shop.destroy
      end

      def handle_order_created(_data)
        raise NotImplementedError, 'WebhookController must defined "handle_order_created".'
      end

      def handle_order_updated(_data)
        raise NotImplementedError, 'WebhookController must defined "handle_order_updated".'
      end

      def handle_product_created(_data)
        raise NotImplementedError, 'WebhookController must defined "handle_product_created".'
      end

      def handle_product_updated(_data)
        raise NotImplementedError, 'WebhookController must defined "handle_product_updated".'
      end

      def handle_product_deleted(_data)
        raise NotImplementedError, 'WebhookController must defined "handle_product_deleted".'
      end

      def set_shop
        @shop = Shop.find(params[:id])
        @shop.refresh_token_if_needed!
      end
    end
  end
end
