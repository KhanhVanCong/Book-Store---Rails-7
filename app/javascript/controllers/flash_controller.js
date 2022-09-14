import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  connect () {
    this.element.style.animation = "fade-in-and-out 4s";
    setTimeout(() => {
      this.element.remove();
    }, 5000);
  }
}
