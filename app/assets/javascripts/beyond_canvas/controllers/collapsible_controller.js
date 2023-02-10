// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction

import { Controller } from "@hotwired/stimulus"
import jquery from 'jquery'
window.$ = jquery

export default class extends Controller {
  static targets = [ 'headline', 'content', 'icon' ]

  toggle() {
    if (this.headlineTarget.dataset.visible == 'true') {
      this.headlineTarget.dataset.visible = 'false';
      this.iconTarget.classList.remove('collapse__icon--open');
      $(`#${this.contentTarget.id}`).slideUp();
    }
    else {
      this.headlineTarget.dataset.visible = 'true';
      this.iconTarget.classList.add('collapse__icon--open');
      $(`#${this.contentTarget.id}`).slideDown();
    }
  }
}
