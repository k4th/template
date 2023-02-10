# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'App authorization', type: :feature, test_helpers: [:cockpit] do
  context 'cockpit app' do
    describe 'with authorization code' do
      before do
        BeyondCanvas.configuration.cockpit_app = true
        BeyondCanvas.configuration.client_credentials = false
        cockpit.go_to_dummy_app
      end

      scenario 'install the app', js: true do
        test_installation
      end

      scenario 'open the app', js: true do
        test_open_app
      end
    end

    describe 'with client credentials' do
      before do
        BeyondCanvas.configuration.cockpit_app = true
        BeyondCanvas.configuration.client_credentials = true
        cockpit.go_to_dummy_app
      end

      scenario 'install the app', js: true do
        test_installation
      end

      scenario 'open the app', js: true do
        test_open_app
      end
    end
  end

  context 'non cockpit app' do
    describe 'with authorization code' do
      before do
        BeyondCanvas.configuration.cockpit_app = false
        BeyondCanvas.configuration.client_credentials = false
        cockpit.go_to_dummy_app
      end

      scenario 'install the app', js: true do
        test_installation
      end

      scenario 'open the app', js: true do
        test_open_app
      end
    end

    describe 'with client credentials' do
      before do
        BeyondCanvas.configuration.cockpit_app = false
        BeyondCanvas.configuration.client_credentials = true
        cockpit.go_to_dummy_app
      end

      scenario 'install the app', js: true do
        test_installation
      end

      scenario 'open the app', js: true do
        test_open_app
      end
    end
  end

  def test_installation
    expect { cockpit.test_authorization }
      .to change { Shop.count }
      .by(1)

    # verify tokens
    expect(current_shop.beyond_access_token).to_not be_nil

    if BeyondCanvas.client_credentials
      expect(current_shop.beyond_refresh_token).to be_nil
    else
      expect(current_shop.beyond_refresh_token).to_not be_nil
    end

    # verify api url
    expect(current_shop.beyond_api_url).to eq(ENV.fetch('TEST_BEYOND_API_URL'))

    # verify reseller
    expect(current_shop.beyond_reseller).to eq(current_shop.to_session.shop.current[:reseller_name])

    # verify webhooks subscriptions
    beyond_webhook_subscriptions = current_shop.to_session.webhook_subscriptions.all[:embedded][:subscriptions]
    expect(beyond_webhook_subscriptions).to include_webhook_subscriptions(BeyondCanvas.webhook_events.to_a)

    # verify refresh token
    expect { current_shop.refresh_token! }.to(change { current_shop.beyond_access_token })

    expect { current_shop.refresh_token_if_needed! }.to_not(change { current_shop.beyond_access_token })
  end

  def test_open_app
    cockpit.test_authorization # install the app
    cockpit.test_authorization # open the dummy app

    expect(page).to have_content(current_shop.beyond_api_url)
  end

  def current_shop
    @current_shop ||= Shop.first
  end
end
