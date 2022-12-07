import { Controller } from "@hotwired/stimulus";
// import flatpickr from "flatpickr";
// Connects to data-controller="timescroll"
const NEWS_API_KEY = "e261e54b338c4a6a95e2b57a942b9445"
export default class extends Controller {
  static targets = ["time", "value", "news", "tickername", "twitterpage"]

  connect() {
    // console.log("timescroll connected");
    // flatpickr(this.timeTarget, {
    //   altInput: true
    // })
  };

  select(e) {
    let datevalue = this.timeTarget.value
    function getaDate(i) {
      let dateToday = new Date();
      dateToday.setDate(dateToday.getDate() - i);
      let datenumber = dateToday.getDate();
      if (datenumber < 10){
        datenumber = "0" + dateToday.getDate();
      }
      let monthnumber = dateToday.getMonth() + 1;
      if (monthnumber < 10){
        monthnumber = "0" + (dateToday.getMonth() + 1);
      }
      return dateToday.getFullYear() + '-' + monthnumber + '-' + datenumber;
  }
    if(datevalue  === 10){
      this.valueTarget.innerHTML = new Date().toISOString().slice(0, 10);
    } else {
      this.valueTarget.innerHTML = getaDate(( 10 - datevalue));
    }
    // this.timeTarget.addEventListener("click", e =>{
    // });
    let enddate = this.valueTarget.innerHTML
    let ticker = this.tickernameTarget.innerHTML
    // console.log(enddate, "this is the enddate")
    // console.log(ticker, "this is the ticker")

    let current_url = new URL(document.URL);
    // console.log("old url", current_url);
    let search_params = current_url.searchParams;
    console.log(search_params);
    // search_params.set("enddate", enddate);
    current_url.search = search_params.toString();
    // console.log("new url", current_url);

    window.history.pushState({}, '', current_url.search);

    const base_url = window.location.href + `/tweets`
    let stock_tweets_url = `${base_url}?enddate=${enddate}`;
    console.log('setting src to: ', stock_tweets_url)

    let turboFrame = document.querySelector('#tweets_stock')
    turboFrame.src = stock_tweets_url

    // this.twitterpageTarget.innerHTML = `${window.location.href} ${twitter_url}`
    // console.log(window.location.href)



    const replace = (data) => {
      let array = data["articles"]
      let top5 = array.slice(0, 5)
      let replacecontent = ''
      top5.forEach(a => {
        replacecontent = replacecontent +
        `<div class="pt-2">
        <div class="flex items-start rounded-xl bg-white p-4 shadow-lg">
        <div class="flex items-center space-x-4">
            <div class="flex-shrink-0">
                <img class="w-20 h-20 rounded-xl" src="${a["urlToImage"]}" alt="news">
            </div>
            <div class="flex flex-col h-20 justify-between">
              <div>
                <a href="${a["url"]}" target="_blank">
                  <p class="text-sm font-medium text-gray-900 dark:text-white"
                  style="display: -webkit-box; -webkit-box-orient: vertical;
                  -webkit-line-clamp: 3; overflow: hidden;">
                    ${a["title"]}
                  </p>
                </a>
              </div>
              <div>
                <p class="text-sm text-gray-500 truncate dark:text-gray-400">
                  ${a["publishedAt"]}
                </p>
              </div>
            </div>
        </div>
      </div>
    </div>`
    });
    this.newsTarget.innerHTML = replacecontent
    }
    let url = `https://newsapi.org/v2/everything?q=${ticker}&from=${enddate}&to=${enddate}&sortBy=popularity&apiKey=${NEWS_API_KEY}`
    fetch(url)
      .then(response => response.json())
      .then((data) => {
        replace(data)
      })
  };
}
