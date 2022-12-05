import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="twitter"
export default class extends Controller {

  connect() {
    console.log("twitter ok")

    const ids = JSON.parse(this.data.get("tweets"))
    console.log(ids)

    window.onload = () => {
      ids.forEach((id) => {
        console.log(id)
        twttr.widgets.createTweet(
          id,
          document.getElementById("tweet"),
          {
            theme: "light",
            cards: "hidden",
            conversastion: "none"
          }
        );
      });
    };
  }
}
