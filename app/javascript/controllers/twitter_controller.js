import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="twitter"
export default class extends Controller {
  connect() {
    console.log("twitter ok")

    twttr.widgets.createTweet(
      "20",
      document.getElementById("tweet"),
      {
        theme: "light"
      }
    );
  }
}
