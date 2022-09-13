// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import jquery from 'jquery';

import "./controllers"

import "popper.js"
import * as bootstrap from "bootstrap"
import "slick-carousel"
import "jquery-modal"

Turbo.session.drive = true
window.jQuery = jquery;
window.$ = jquery;

$('#js-instagram__carousel').slick({
  slidesToShow: 3,
  dot: false,
  arrows: false,
});