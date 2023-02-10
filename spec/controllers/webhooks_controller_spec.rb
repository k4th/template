# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BeyondCanvas::WebhooksController, type: :controller do
  # Routes
  ######################################################################################################################

  describe 'routes' do
    it "POST\t/shops/:id/beyond_webhooks" do
      id = rand(1..10)
      is_expected.to route(:post, "shops/#{id}/beyond_webhooks")
        .to(controller: 'beyond_canvas/webhooks',
            action: 'receive',
            id:)
    end
  end
end
