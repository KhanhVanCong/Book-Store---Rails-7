import "@hotwired/turbo-rails"
import "@fortawesome/fontawesome-free/js/all"
import * as ActiveStorage from "@rails/activestorage"
import "./src/direct_uploads"

import "./src/jquery"
import "popper.js"
import * as bootstrap from "bootstrap"

import "./cms/controllers"

Turbo.session.drive = true
ActiveStorage.start()