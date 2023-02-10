import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets =  ['value']

  display(evt) {
    const fileName = evt.target.value.split('\\').pop();
    if (fileName.length == 0) return;

    this.valueTarget.innerHTML = fileName;

    this.dispatch('display');
  }
}
