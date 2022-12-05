import { Application } from "@hotwired/stimulus"
import { Turbo } from "@hotwired/turbo-rails"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }


// Logic for Custom Modal - Find in app/views/shared/_confirm_modals
Turbo.setConfirmMethod((message, element) => {
  let dialog = document.getElementById("turbo-confirm");
  dialog.querySelector("p").textContent = message;
  dialog.showModal();

  return new Promise((resolve, reject) => {
    dialog.addEventListener("close", () => {
      resolve(dialog.returnValue == "confirm")
    }, { once: true })
  })
})
