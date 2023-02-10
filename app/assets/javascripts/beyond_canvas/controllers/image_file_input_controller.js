import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets =  ['content', 'input', 'placeholder']

  display(e) {
    const elementFather = this.contentTarget;
    this.removePlaceholder();

    const arr = Array.from(e.target.files);

    arr.forEach(file => {
      const reader = new FileReader();
      reader.readAsDataURL(file);

      reader.onload = function () {
        const figure = document.createElement('figure');
        const img = document.createElement('img');

        figure.classList.add('attachment', 'attachment--preview');
        figure.setAttribute('preview', true);
        img.setAttribute('src', reader.result);

        figure.append(img);
        elementFather.append(figure);
      };
    });
  }

  removeImages() {
    const figures = this.contentTarget.getElementsByTagName('figure');

    while (figures[0]) figures[0].parentNode.removeChild(figures[0])
  }

  removePlaceholder() {
    this.contentTarget.querySelector('[data-image-file-input-target=placeholder]')?.remove()
  }
}
