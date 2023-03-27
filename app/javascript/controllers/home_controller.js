import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="home"
export default class extends Controller {
  connect() {
    $(".js-featured__carousel").slick({
      slidesToShow: 4,
      dot: false,
      arrows: false,
      autoplay: true,
      centerMode: false,
      autoplaySpeed: 2000,
      responsive: [
        {
          breakpoint: 1367,
          settings: {
            centerPadding: '300px',
          },
        },
        {
          breakpoint: 1025,
          settings: {
            slidesToShow: 3,

          },
        },
        {
          breakpoint: 780,
          settings: {
            slidesToShow: 2,
          },
        },
        {
          breakpoint: 480,
          settings: {
            slidesToShow: 2,
          },
        },
      ],
    });
  }
}
