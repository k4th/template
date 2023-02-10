import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets =  ['flash']

  initialize() {
    this.flashTarget.style.right = `-${this.flashTarget.offsetWidth}px`
    this.flashTarget.style.removeProperty('visibility')

    setTimeout(() => {
      this.flashTarget.classList.add('flash--shown')
    }, 100)
  }

  close() {
    const event = new Event('bc.flash.hide', { bubbles: true })
    this.flashTarget.dispatchEvent(event)

    this.flashTarget.classList.remove('flash--shown')
    setTimeout(() => {
      this.flashTarget.remove()
    }, 700)
  }

  disconnect() {
    const event = new Event('bc.flash.hidden', { bubbles: true })
    this.flashTarget.dispatchEvent(event)
  }
}
