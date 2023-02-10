# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BeyondCanvas::SystemController, type: :controller do
  # Routes
  ######################################################################################################################

  describe 'routes' do
    it "PUT\t/update_locale" do
      is_expected.to route(:put, '/update_locale')
        .to(controller: 'beyond_canvas/system',
            action: 'update_locale')
    end

    it 'sets a cookie locale' do
      locale = 'en-GB'
      post :update_locale, params: { system: { locale: } }

      expect(cookies[:locale]).to eq(locale)
    end
  end
end
