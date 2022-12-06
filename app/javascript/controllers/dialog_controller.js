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
  }

  close(event) {
    event.preventDefault()
    this.element.remove()
    this.element.closest.src = undefined
  }

  initDialog() {
    const modalHTML = this.element.dataset.modalContent
    const dialog = document.createElement('dialog')
    document.body.insertAdjacentElement('beforeend', dialog)
    dialog.innerHTML = modalHTML
    return dialog
  }
}
