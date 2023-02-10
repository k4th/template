# frozen_string_literal: true

module BeyondCanvas
  class WebhookOverridesGenerator < Rails::Generators::Base
    desc 'Creates an inherited Webhook controller in the app/controllers folder'

    source_root File.expand_path('templates', __dir__)

    def create_controller
      template 'webhooks_controller_override.rb', 'app/overrides/controllers/beyond_canvas/webhooks_controller_override.rb'
    end

    def add_application
      application 'overrides = "#{Rails.root}/app/overrides"
Rails.autoloaders.main.ignore(overrides)

config.to_prepare do
  Dir.glob("#{overrides}/**/*_override.rb").each do |override|
    load override
  end
end'
    end
  end
end
