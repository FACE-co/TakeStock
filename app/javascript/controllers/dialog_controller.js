import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="dialog"
export default class extends Controller {
  connect() {
    this.dialog = this.initDialog()
  }

  disconnect() {
    this.dialog.remove()
  }

  open(event) {
    event.preventDefault()
    this.dialog.showModal()
    let cancelButton = document.querySelectorAll("#cancel")
    cancelButton.forEach(b => b.addEventListener("click", (e) => {
      console.log(cancelButton)
      let openeddialog = document.querySelectorAll("#thisdialog");
      openeddialog.forEach(e => e.close())
    }))
  }

  // close(event) {
  //   this.element.closest("dialog").close()
  //   document.URL = "/#"
  // }

  initDialog() {
    const modalHTML = this.element.dataset.modalContent
    const dialog = document.createElement('dialog')
    document.body.insertAdjacentElement('beforeend', dialog)
    dialog.innerHTML = modalHTML
    dialog.setAttribute("id", "thisdialog");
    return dialog
  }
}
