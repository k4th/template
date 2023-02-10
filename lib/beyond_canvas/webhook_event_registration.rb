# frozen_string_literal: true

module BeyondCanvas
  module WebhookEventRegistration
    def register_webhook_event(*events)
      events.map(&:to_s).each do |event|
        webhook_events.add(event) if Constants::WEBHOOK_EVENTS.include?(event) && webhook_events.exclude?(event)
      end
    end

    def webhook_events
      @webhook_events ||= Set.new
    end

    def clear_webhook_events!
      webhook_events.clear
    end

    alias register_webhook_events register_webhook_event
  end
end
