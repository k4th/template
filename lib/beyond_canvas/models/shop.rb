# frozen_string_literal: true

module BeyondCanvas
  module Models
    module Shop
      extend ActiveSupport::Concern

      include Concerns::Authentication
      include Concerns::Utils
      include Concerns::Webhook
    end
  end
end
