import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="twitter"
export default class extends Controller {
  static values = {
    tweets: Array
  }

  connect() {
    console.log("twitter ok")

    console.log(this.tweetsValue)

    this.tweetsValue.forEach((id) => {
      console.log(id)
      twttr.widgets.createTweet(
        id,
        document.getElementById("tweet"),
        {
          theme: "light",
          cards: "hidden",
          width: "100%",
          conversastion: "none"
        }
      );
    });
  }
}
