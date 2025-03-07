import { Application } from "@hotwired/stimulus"
import "./search_toggle";

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }
