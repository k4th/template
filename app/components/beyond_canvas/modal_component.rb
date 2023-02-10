# frozen_string_literal: true

module BeyondCanvas
  class ModalComponent < BeyondCanvas::ApplicationComponent
    renders_one :footer

    option :title, proc(&:to_s)
    option :dismiss_icon, default: proc { false }
    option :dismiss_submit, default: proc { false }
    option :dismiss_click, default: proc { false }
    option :dismiss_keyup, default: proc { false }
    option :footer_alignment, proc { |value| "--#{value}" }, default: proc { 'left' }

    def modal_actions
      actions = []

      actions << 'turbo:submit-end->modal#submitEnd' if @dismiss_submit
      actions << 'click@window->modal#closeBackground' if @dismiss_click
      actions << 'keyup@window->modal#closeWithKeyboard' if @dismiss_keyup

      actions.join(' ')
    end
  end
end
