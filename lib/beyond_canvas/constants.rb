# frozen_string_literal: true

module BeyondCanvas
  module Constants
    WEBHOOK_EVENTS = [
      'order.created',
      'order.updated',
      'product.created',
      'product.updated',
      'product.deleted',
      'app.uninstalled',
      'app.deleted'
    ].freeze
  end
end
