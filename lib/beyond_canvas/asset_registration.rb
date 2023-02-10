# frozen_string_literal: true

module BeyondCanvas
  module AssetRegistration
    def register_stylesheet(path, options = {})
      stylesheets[path] = options
    end

    def stylesheets
      @stylesheets ||= {}
    end

    def clear_stylesheets!
      stylesheets.clear
    end
  end
end
