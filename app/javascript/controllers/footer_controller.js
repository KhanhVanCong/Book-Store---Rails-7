import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="footer"
export default class extends Controller {
  connect() {
    $(this.element).slick({
      slidesToShow: 3,
      dot: false,
      arrows: false,
    });
  }

  disconnect () {
    $(this.element).remove()
  }
}
