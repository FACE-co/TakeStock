import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="stock-page"
export default class extends Controller {
  connect() {
    console.log("hi")
  }
}
