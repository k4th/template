# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  # Routes
  ######################################################################################################################

  context 'cockpit app' do
    before do
      BeyondCanvas.configuration.cockpit_app = true
      I18n.available_locales = %w[fr-CH de-DE en-GB en]
      I18n.default_locale = 'en'

      session[:shop_id] = FactoryBot.create(:shop,
                                            beyond_api_url: ENV.fetch('TEST_BEYOND_API_URL')).id

      request.headers['HTTP_ACCEPT_LANGUAGE'] = 'en-GB, en;q=0.9, fr;q=0.8, de-DE, de;q=0.7, *;q=0.5'
    end

    describe '#index' do
      before { get :index }
      it { should use_before_action(:validate_app_installation_request!) }
      it { should respond_with(200...299) }
      it { should render_template('index') }
    end

    describe 'locale management' do
      it 'sets the shop locale regardless of the browser compatible locales or I18n default locale' do
        get :index
        expect(cookies[:locale].to_s).to eq('de-DE')
      end

      it 'overwrites the cookie locale if it is invalid' do
        cookies[:locale] = 'invalid'
        expect(cookies[:locale]).to eq('invalid')

        get :index
        expect(cookies[:locale].to_s).to eq('de-DE')
      end
    end
  end

  context 'non cockpit app' do
    before do
      BeyondCanvas.configuration.cockpit_app = false
      I18n.available_locales = %w[de en]
      I18n.default_locale = 'de'
    end

    describe '#index' do
      before { get :index }
      it { should use_before_action(:validate_app_installation_request!) }
      it { should respond_with(200...299) }
      it { should render_template('index') }
    end

    describe 'locale management' do
      describe 'sets the I18n available locale with the highest weight within the browser locales' do
        it 'sets the first available locale' do
          request.headers['HTTP_ACCEPT_LANGUAGE'] = 'fr;q=0.9, de;q=0.8, en;q=0.7, *;q=0.5'
          get :index
          expect(cookies[:locale].to_s).to eq('de')
        end

        it 'sets the second available locale' do
          request.headers['HTTP_ACCEPT_LANGUAGE'] = 'fr;q=0.9, en;q=0.8, de;q=0.7, *;q=0.5'
          get :index
          expect(cookies[:locale].to_s).to eq('en')
        end
      end
    end
  end
end
