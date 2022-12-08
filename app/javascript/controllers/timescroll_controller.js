import { Controller } from "@hotwired/stimulus";
// Connects to data-controller="timescroll"
const NEWS_API_KEY = "fb75ef613f12441dae19903662d6de18"
export default class extends Controller {
  static targets = ["time", "value", "valueshow", "news", "tickername", "twitterpage"]

  connect() {
  };

  select(e) {
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

    function showaDate(i) {
      let dateToday = new Date();
      dateToday.setDate(dateToday.getDate() - i);
      return dateToday.toLocaleDateString('en-us', { year:"numeric", month:"short", day:"numeric"});
    }

    function replace(data){
      let array = data["articles"]
      let top7 = array.slice(0, 7)
      let replacecontent = ''

      top7.forEach(a => {
        let newsdate = new Date(Date.parse(a["publishedAt"]))
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
                    <p class="text-sm font-medium text-gray-900 "
                    style="display: -webkit-box; -webkit-box-orient: vertical;
                    -webkit-line-clamp: 3; overflow: hidden;">
                      ${a["title"]}
                    </p>
                  </a>
                </div>
                <div>
                  <p class="text-sm text-gray-500 truncate">
                    ${newsdate.toLocaleDateString("en-us" , {
                      month: "short",
                      day: "numeric",
                      year: "numeric",
                      hour: "2-digit",
                      minute: "2-digit",
                      second: "2-digit",
                      hour12: false
                    })}
                  </p>
                </div>
              </div>
          </div>
          </div>
        </div>`
      });
     return replacecontent
    }

    let datevalue = this.timeTarget.value
    if(datevalue  === 6){
      this.valueTarget.innerHTML = new Date().toISOString().slice(0, 10);
      this.valueshowTarget.innerHTML = new Date().toLocaleDateString('en-us', { year:"numeric", month:"short", day:"numeric"})
    } else {
      this.valueTarget.innerHTML = getaDate(( 6 - datevalue));
      this.valueshowTarget.innerHTML = showaDate(( 6 - datevalue));
    }

    let enddate = this.valueTarget.innerHTML
    let ticker = this.tickernameTarget.innerHTML

    //GET tweeter refresh due to timescroll change
    let current_url = new URL(document.URL);
    let search_params = current_url.searchParams;
    current_url.search = search_params.toString();
    window.history.pushState({}, '', current_url.search);
    const base_url = window.location.href + `/tweets`
    let stock_tweets_url = `${base_url}?enddate=${enddate}`;
    let turboFrame = document.querySelector('#tweets_stock')
    turboFrame.src = stock_tweets_url

    //GET news change due to timescroll change
    let url = `https://newsapi.org/v2/everything?q=${ticker}&from=${enddate}&to=${enddate}&sortBy=popularity&apiKey=${NEWS_API_KEY}`
    fetch(url)
      .then(response => response.json())
      .then((data) => {
        this.newsTarget.innerHTML = replace(data);
      })
  }

}
