# frozen_string_literal: true

module BeyondCanvas
  module RequestValidation
    extend ActiveSupport::Concern

    private

    def validate_app_installation_request!
      bad_request unless app_installation_params? && valid_signature?(params[:signature],
                                                                      app_installation_data,
                                                                      BeyondApi.configuration.client_secret)
    end

    def app_installation_params?
      !(params[:code].nil? ||
        params[:signature].nil? ||
        params[:return_url].nil? ||
        params[:api_url].nil? ||
        params[:access_token_url].nil?)
    end

    def app_installation_data
      "#{params[:code]}:#{params[:access_token_url]}"
    end

    def valid_signature?(signature, data, secret)
      signature = CGI.unescape(signature) unless base64?(signature)
      digest = OpenSSL::Digest.new('SHA1')
      hmac = OpenSSL::HMAC.digest(digest, secret, data)

      signature == Base64.encode64(hmac).chop
    end

    def signature_params
      data = URI.parse(request.original_url).to_s
      data << ":#{request.body.read}" if request.body.read.present?
      data
    end

    def base64?(value)
      value.is_a?(String) && Base64.strict_encode64(Base64.decode64(value)) == value
    end
  end
end
