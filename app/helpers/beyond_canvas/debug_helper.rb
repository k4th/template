# frozen_string_literal: true

module BeyondCanvas
  module DebugHelper
    def debug_mode?
      ::Rails.env.development? && ::BeyondCanvas.debug_mode
    end
  end
end
