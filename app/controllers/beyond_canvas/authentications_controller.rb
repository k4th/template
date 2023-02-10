# frozen_string_literal: true

require_dependency 'beyond_canvas/application_controller'

module BeyondCanvas
  class AuthenticationsController < ApplicationController
    include RequestValidation

    skip_around_action :switch_locale

    after_action :set_iframe_ancestor_url, only: :callback, unless: -> { Rails.env.test? }

    before_action :validate_app_installation_request!,
                  only: :callback,
                  unless: -> { Rails.env.development? && BeyondCanvas.client_credentials }

    def callback
      shop = Shop.find_or_initialize_by(beyond_api_url: params[:api_url])

      if shop.authenticated?
        open_app(shop)
      else
        install(shop)
      end
    end

    private

    def open_app(shop)
      shop.authenticate!(params[:code])

      reset_session
      log_in shop

      cookies.delete(:locale)

      redirect_to after_log_in_path
    end

    def install(shop)
      shop.authenticate(params[:code])
      shop.set_reseller
      shop.save

      shop.http_host = request.env.fetch('HTTP_HOST')
      shop.subscribe_to_beyond_webhooks

      redirect_to after_installation_path, allow_other_host: true
    end

    def after_log_in_path
      BeyondCanvas.open_app_url
    end

    def after_installation_path
      params[:return_url]
    end

    def set_iframe_ancestor_url
      session[:iframe_ancestor_url] =
        request.referer || request['return_url'] ||
          "https://#{current_shop.to_session.shop.current[:primary_hostname]} #{current_shop.url}"
    end
  end
end
