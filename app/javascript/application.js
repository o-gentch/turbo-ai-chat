// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Custom Turbo Stream action: scroll messages list to bottom
import { StreamActions } from "@hotwired/turbo"

StreamActions.scroll_to_bottom = function () {
  const el = document.getElementById(this.target)
  if (el) {
    requestAnimationFrame(() => { el.scrollTop = el.scrollHeight })
  }
}
