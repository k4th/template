# frozen_string_literal: true

require 'rails/generators/active_record'

module BeyondCanvas
  class ModelGenerator < ActiveRecord::Generators::Base
    desc 'Generates the Shop model and the database migration file'

    source_root File.expand_path('templates', __dir__)

    def migration
      migration_path = File.join('db', 'migrate')

      migration_template('migration.erb',
                         "#{migration_path}/beyond_canvas_create_#{table_name}.rb",
                         migration_version:)
    end

    def model
      template 'model.erb', File.join("app/models/#{file_path}.rb")
    end

    private

    def rails5_and_up?
      Rails::VERSION::MAJOR >= 5
    end

    def migration_version
      "[#{Rails::VERSION::MAJOR}.#{Rails::VERSION::MINOR}]" if rails5_and_up?
    end
  end
end
