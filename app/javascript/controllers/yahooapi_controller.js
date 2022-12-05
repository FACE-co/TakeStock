import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="yahooapi"
export default class extends Controller {
  static targets = ["basicinfo", "tickername"]
  connect() {
    console.log("yahoo-api connected")
    let ticker = this.tickernameTarget.innerHTML
    console.log(ticker)
    let url = `https://query1.finance.yahoo.com/v8/finance/chart/${ticker}?&interval=1d&range=7d`
    fetch(url)
      .then(response => response.json())
      .then((data) => {
        console.log(data)
      })
  }

}
