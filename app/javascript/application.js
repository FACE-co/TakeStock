// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"
import "bootstrap"
import { initCursor } from "./custom/custom_cursor"

initCursor()



// import { initAlgolia } from "./custom/algolia"

// document.addEventListener("turbo:load", () => {
  //   initAlgolia()
  // })

