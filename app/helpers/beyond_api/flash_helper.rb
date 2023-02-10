# frozen_string_literal: true

module BeyondApi
  module FlashHelper
    def beyond_api_error_flash(response, options = {})
      return unless response.is_a? BeyondApi::Error

      options.merge! default: I18n.t('beyond_api.errors.generic_error', trace_id: response.trace_id)

      flash.now[:error] = I18n.t("beyond_api.errors.#{response.error_id}", **options)

      yield if block_given?
    end
  end
end
