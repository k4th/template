# frozen_string_literal: true

module BeyondCanvas
  class DotenvGenerator < Rails::Generators::Base
    desc 'Configures the app to use the `dotenv-rails`` gem'

    source_root File.expand_path('templates', __dir__)

    def dotenv_gem
      gem_group :development, :test do
        gem 'dotenv-rails'
      end
    end

    def dotenv_beyond_api
      gsub_file 'config/initializers/beyond_api.rb',
                /config.client_id\s=\snil/,
                "config.client_id     = ENV['BEYOND_CLIENT_ID']"

      gsub_file 'config/initializers/beyond_api.rb',
                /config.client_secret\s=\snil/,
                "config.client_secret = ENV['BEYOND_CLIENT_SECRET']"
    end

    def dotenv_application
      gsub_file 'config/application.rb',
                /config.active_record.encryption.primary_key\s*=\s*['"][a-zA-Z0-9]{32}['"]/,
                "config.active_record.encryption.primary_key         = ENV['ENCRYPTION_PRIMARY_KEY']"

      gsub_file 'config/application.rb',
                /config.active_record.encryption.deterministic_key\s*=\s*['"][a-zA-Z0-9]{32}['"]/,
                "config.active_record.encryption.deterministic_key   = ENV['ENCRYPTION_DETERMINISTIC_KEY']"

      gsub_file 'config/application.rb',
                /config.active_record.encryption.key_derivation_salt\s*=\s*['"][a-zA-Z0-9]{32}['"]/,
                "config.active_record.encryption.key_derivation_salt = ENV['ENCRYPTION_KEY_DERIVATION_SALT']"
    end

    def dotenv_gitignore
      inject_into_file '.gitignore' do
        <<~HEREDOC
          # Ignore dotenv files
          .env
          .env*.local
        HEREDOC
      end
    end

    def dotenv_file
      template '.env.erb', '.env'
      copy_file '.env.template', '.env.template'
    end
  end
end
