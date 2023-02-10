# frozen_string_literal: true

module BeyondCanvas
  class BeyondTranslationsGenerator < Rails::Generators::Base
    desc 'Copy Beyond API translation'

    source_root File.expand_path('../../../..', __dir__)

    def copy_beyond_api_translations
      template_translation_file = File.join('config','locales', 'beyond_api.en.yml')
      translation_file = File.join(destination_root, 'config', 'locales', 'beyond_api.en.yml')

      copy_file template_translation_file, translation_file
    end
  end
end
