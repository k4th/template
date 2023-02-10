# frozen_string_literal: true

module BeyondCanvas
  class Engine < ::Rails::Engine
    config.autoload_paths << File.expand_path(root.join('app/components'))

    initializer 'beyond_canvas.assets.precompile' do |app|
      ::BeyondCanvas.stylesheets.each do |path, _|
        app.config.assets.precompile << path
      end

      app.config.assets.precompile << 'beyond_canvas_manifest.js'
    end

    config.before_initialize do
      ActiveSupport.on_load :action_controller do
        include ::BeyondCanvas::AuthenticationsHelper
        include ::BeyondCanvas::LocaleManagement
        include ::BeyondCanvas::RequestValidation
        include ::BeyondCanvas::StatusCodes
        include ::BeyondApi::FlashHelper
      end
    end

    initializer 'beyond_canvas.session' do |app|
      if BeyondCanvas.cockpit_app == true && Rails.env.production?
        app.config.session_store :cookie_store,
                                 secure: true,
                                 same_site: :none
      end
    end

    initializer 'beyond_canvas.add_middleware' do |app|
      app.middleware.use BeyondCanvas::Middleware::CockpitAppHeader if BeyondCanvas.cockpit_app == true
    end
  end
end
