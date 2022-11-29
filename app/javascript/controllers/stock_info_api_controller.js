import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stock-info-api"
export default class extends Controller {
  static targets = [ "form" ]
  connect() {
    console.log("stock-info-api connected")
  }

  search(event) {
    event.preventDefault()
    // debugger
    console.log(this.formTarget.value)
    // this.formTarget.textContent =
    // `Hello, ${this.nameTarget.value}!`
  }
}
