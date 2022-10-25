import "@hotwired/turbo-rails"
import * as ActiveStorage from "@rails/activestorage"
import "./src/direct_uploads"

Turbo.session.drive = true
ActiveStorage.start()