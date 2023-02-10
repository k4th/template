# frozen_string_literal: true

module BeyondCanvas
  class InstallGenerator < Rails::Generators::Base
    desc 'Installs Beyond Canvas and generates the necessary files'

    class_option :skip_beyond_api, type: :boolean,
                                   default: false,
                                   desc: 'Skip the installation of Beyond Api'

    class_option :skip_encryption, type: :boolean,
                                   default: false,
                                   desc: "Skip setting Active Record's encryption configuration on `config/application`"

    class_option :skip_dotenv, type: :boolean,
                               default: false,
                               desc: 'Skip installing and configuring `dotenv-rails` gem'

    source_root File.expand_path('templates', __dir__)

    def copy_initializer
      template 'beyond_canvas.rb.erb', 'config/initializers/beyond_canvas.rb'
    end

    def generate_shop_model
      generate 'beyond_canvas:model shop'
    end

    def install_beyond_api
      return if options[:skip_beyond_api]

      generate 'beyond_canvas:beyond_api'
    end

    def active_record_encryption
      return if options[:skip_encryption]

      generate 'beyond_canvas:active_record_encryption'
    end

    def configure_dotenv
      return if options[:skip_dotenv]

      generate 'beyond_canvas:dotenv'
    end

    def generate_static_files
      generate 'beyond_canvas:static_files'
    end

    def update_gitignore
      gsub_file Rails.root.join('.gitignore').to_s, "/public/assets\n", ''
    end

    def copy_beyond_api_translations
      generate 'beyond_canvas:beyond_translations'
    end

    def check_dependencies
      unless defined? Importmap
        system 'bundle add importmap-rails'
        system 'rails importmap:install'
      end

      unless defined? Stimulus
        system 'bundle add stimulus-rails'
        system 'rails stimulus:install'
      end

      return unless defined? Turbo

      system 'bundle add turbo-rails'
      system 'rails turbo:install'
    end

    def pin_js_controllers
      insert_into_file Rails.root.join('config/importmap.rb').to_s,
                       "pin 'jquery', to: 'https://ga.jspm.io/npm:jquery@3.6.0/dist/jquery.js'\n" \
                       'pin_all_from ' \
                       "BeyondCanvas::Engine.root.join('app/assets/javascripts/beyond_canvas/controllers'), " \
                       "under: 'controllers', to: 'beyond_canvas/controllers'\n"
    end
  end
end
