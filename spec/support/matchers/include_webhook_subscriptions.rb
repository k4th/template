# frozen_string_literal: true

RSpec::Matchers.define :include_webhook_subscriptions do |expected_webhook_subscriptions|
  match do |beyond_webhook_subscriptions|
    beyond_webhook_subscriptions.pluck(:event_types)
                                .find { |ws| ws.sort == expected_webhook_subscriptions.sort }
                                .present?
  end

  failure_message do |beyond_webhook_subscriptions|
    "error: expected to find webhook subscriptions `#{expected_webhook_subscriptions}`\n" \
      "\t but found #{beyond_webhook_subscriptions.pluck(:event_types)}"
  end
end
