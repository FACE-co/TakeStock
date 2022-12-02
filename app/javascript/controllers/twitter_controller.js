import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="twitter"
export default class extends Controller {
  connect() {
    console.log("twitter ok")

    // const query = `https://api.twitter.com/2/tweets/search/recent?query=${this.data.get("ticker")}`
    // console.log(query)

    // const params = {
    //   method: 'GET',
    //   headers: {
    //     'Authorization': 'Bearer '+ "AAAAAAAAAAAAAAAAAAAAAFKOjwEAAAAAc6ZcYma1nuXCiCsxrW041C%2BsR%2Fc%3DMV1FvaN9QRiL212vBpmKhWHQ2eDYZmrWznM6By8WTfUCeE7Avk",
    //   }
    // };

    // fetch(query, params)
    //   .then(response => response.json())
    //   .then((data) => {
    //     console.log(data)
    //   });

    twttr.widgets.createTweet(
      "1598050795882442752",
      document.getElementById("tweet"),
      {
        theme: "light"
      }
    );
  }
}
