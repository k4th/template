# frozen_string_literal: true

module BeyondCanvas
  module CockpitAppHelper
    def cockpit_app?
      ::BeyondCanvas.cockpit_app == true
    end

    def action_bar_content?
      content_for?(:action_bar_left) || content_for?(:action_bar_right)
    end

    def menu_content?
      BeyondCanvas.menu_items.any?
    end
  end
end
