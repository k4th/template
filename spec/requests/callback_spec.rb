# frozen_string_literal: true

require 'rails_helper'

CALLBACK_PARAMS = [:access_token_url, :api_url, :code, :return_url, :signature].freeze

RSpec.describe 'Authentication', type: :request do
  describe 'GET /callback' do
    it 'is bad request if signature validation is not successful' do
      expect do
        api_url = ENV.fetch('TEST_BEYOND_API_URL')
        access_token_url = "#{api_url}/oauth/token"
        code = SecureRandom.urlsafe_base64(5)
        return_url = ENV.fetch('TEST_COCKPIT_URL').gsub('/cockpit', ENV.fetch('TEST_CUSTOM_APP_URL'))
        signature = SecureRandom.uuid

        get "/callback?access_token_url=#{access_token_url}&" \
            "api_url=#{api_url}&code=#{code}&return_url=#{return_url}&signature=#{signature}"
      end.to raise_error(ActionController::BadRequest)
    end

    CALLBACK_PARAMS.each do |param|
      it "is bad request if #{param} is missing" do
        expect do
          params = {
            api_url: ENV.fetch('TEST_BEYOND_API_URL'),
            access_token_url: "#{ENV.fetch('TEST_BEYOND_API_URL')}/oauth/token",
            code: SecureRandom.urlsafe_base64(5),
            return_url: ENV.fetch('TEST_COCKPIT_URL').gsub('/cockpit', ENV.fetch('TEST_CUSTOM_APP_URL')),
            signature: SecureRandom.uuid
          }
          url = CALLBACK_PARAMS.reject { |e| e == param }
                               .map { |e| "#{e}=#{params[e]}&" }.reduce(:+).chop
          get "/callback?#{url}"
        end.to raise_error(ActionController::BadRequest)
      end
    end
  end
end
