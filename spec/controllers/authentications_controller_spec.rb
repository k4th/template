# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BeyondCanvas::AuthenticationsController, type: :controller do
  # Routes
  ######################################################################################################################

  describe 'routes' do
    it "GET\t/callback" do
      is_expected.to route(:get, '/callback')
        .to(controller: 'beyond_canvas/authentications',
            action: 'callback')
    end
  end
end
