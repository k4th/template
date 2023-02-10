import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['modal', 'modalContent']

  connect() {
  }

  // hide modal
  // action: "modal#hideModal"
  hideModal() {
    this.element.parentElement.removeAttribute("src")
    // Remove src reference from parent frame element
    // Without this, turbo won't re-open the modal on subsequent click
    this.modalTarget.remove()
  }

  // hide modal on successful form submission
  // action: "turbo:submit-end->modal#submitEnd"
  submitEnd(e) {
    if (e.detail.success) {
      this.hideModal()
    }
  }

  // hide modal when clicking ESC
  // action: "keyup@window->modal#closeWithKeyboard"
  closeWithKeyboard(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  }

  // hide modal when clicking outside of modal
  // action: "click@window->modal#closeBackground"
  closeBackground(e) {
    if (e && this.modalContentTarget.contains(e.target)) {
      return;
    }
    this.hideModal()
  }
}
