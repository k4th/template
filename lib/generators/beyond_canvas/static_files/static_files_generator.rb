# frozen_string_literal: true

module BeyondCanvas
  class StaticFilesGenerator < Rails::Generators::Base
    desc 'Copy static files into public folder'

    source_root File.expand_path('templates', __dir__)

    def copy_public
      copy_folder 'pages', 'public'
    end

    def copy_assets
      copy_folder 'assets/js', 'public/assets/js'
      copy_folder 'assets/css', 'public/assets/css'
    end

    private

    def copy_folder(folders, app_folder)
      Dir.each_child(File.join(__dir__, 'templates', folders)) do |file|
        copy_file File.join(folders, file), File.join(app_folder, File.basename(file))
      end
    end
  end
end
