# frozen_string_literal: true

require_dependency 'beyond_canvas/application_controller'

module BeyondCanvas
  class SystemController < ApplicationController
    skip_around_action :switch_locale

    def update_locale
      cookies[:locale] = locale_cookie_hash(system_locale_params[:locale])

      redirect_back(fallback_location: main_app.root_path)
    end

    private

    #
    # Strong parameters for locale switch
    #
    def system_locale_params
      params.require(:system).permit(:locale)
    end
  end
end
