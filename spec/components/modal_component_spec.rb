# frozen_string_literal: true

require 'rails_helper'

RSpec.describe BeyondCanvas::ModalComponent, type: :component do
  describe 'modal component' do
    it 'is rendered with default options' do
      render_preview(:default, from: ModalComponentPreview)

      verify_modal_structure(title:'Default modal title',
                             content: 'Default modal content',
                             dismiss_icon: false,
                             actions: [])
    end

    it 'has only the dismiss icon' do
      render_preview(:with_dismiss_icon, from: ModalComponentPreview)

      verify_modal_structure(title:'Modal with dismiss icon title',
                             content: 'Modal with dismiss icon content',
                             dismiss_icon: true,
                             actions: [])
    end

    it 'has a footer' do
      render_preview(:with_footer, from: ModalComponentPreview)

      verify_modal_structure(title: 'Modal with footer title',
                             content: 'Modal with footer content',
                             footer: true,
                             dismiss_icon: false,
                             actions: [])

      expect(page).to have_selector(:link_or_button, 'Click me')
    end

    it 'has a footer with spaced-between alignment' do
      render_preview(:with_spaced_footer, from: ModalComponentPreview)

      verify_modal_structure(title: 'Modal title',
                             content: 'Modal with space-between alignment',
                             footer: true,
                             alignment: 'space-between',
                             dismiss_icon: true,
                             actions: [])

      expect(page).to have_selector(:link_or_button, 'Delete')
      expect(page).to have_selector(:link_or_button, 'Cancel')
      expect(page).to have_selector(:link_or_button, 'Save')
    end

    it 'listens to multiple events and has the dismiss icon' do
      render_inline(described_class.new(title: 'Last modal',
                                        dismiss_icon: true,
                                        dismiss_click: true,
                                        dismiss_keyup: true))

      verify_modal_structure(title: 'Last modal',
                             content: '',
                             dismiss_icon: true,
                             actions: ['keyup@window->modal#closeWithKeyboard', 'click@window->modal#closeBackground'])
    end

    def verify_modal_structure(title:, content:, footer: false, alignment: 'left', dismiss_icon: false, actions: [])
      expect(page).to have_css('.modal__dialog')
      expect(page).to have_css('.modal__content')
      expect(page).to have_css('.modal__header')
      expect(page).to have_css('.modal__title')

      if footer
        expect(page).to have_css('.modal__footer')
        expect(page).to have_css(".form__actions--#{alignment}")
      else
        expect(page).to_not have_css('.modal__footer')
      end

      page.find('.modal__title', text: title)
      page.find('.modal__body', text: content)

      if dismiss_icon
        expect(page).to have_css('.modal__close')
        expect(page.find('.modal__close')['data-action']).to include('click->modal#hideModal')
      else
        expect(page).to_not have_css('.modal__close')
      end

      generated_actions = page.find("div[data-controller='modal']")['data-action'].split(' ')
      expect(generated_actions).to match_array(actions)
    end
  end
end
