# frozen_string_literal: true

require 'rails/generators/active_record'

module BeyondCanvas
  class ActiveRecordEncryptionGenerator < Rails::Generators::Base
    desc 'Sets up Active Record Encryption on `config/application`'

    def active_record_encryption
      application do
        <<-RUBY
          # Beyond Canvas uses Rails 7's Active Record Encryption to encrypt the
          # `beyond_access_token` and the `beyond_refresh_token`.
          #
          # These keys are needed to make it work. Store them safely on environment
          # variables or using the Rails Encrypted Credentials:
          #
          config.active_record.encryption.primary_key         = '#{SecureRandom.alphanumeric(32)}'
          config.active_record.encryption.deterministic_key   = '#{SecureRandom.alphanumeric(32)}'
          config.active_record.encryption.key_derivation_salt = '#{SecureRandom.alphanumeric(32)}'

        RUBY
      end
    end
  end
end
