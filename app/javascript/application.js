// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./src/jquery"

import "popper.js"
import * as bootstrap from "bootstrap"
import "slick-carousel"
import "jquery-modal"

import "./controllers"
Turbo.session.drive = true