import { Controller } from "@hotwired/stimulus";
// Connects to data-controller="timescroll"
const NEWS_API_KEY = "0aed0a55fa8b4bd08d5896247adb469f"
export default class extends Controller {
  static targets = ["time", "value", "valueshow", "news", "twitterpage"]

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

    let datevalue = this.timeTarget.value
    if(datevalue  === 6){
      this.valueTarget.innerHTML = new Date().toISOString().slice(0, 10);
      this.valueshowTarget.innerHTML = new Date().toLocaleDateString('en-us', { year:"numeric", month:"short", day:"numeric"})
    } else {
      this.valueTarget.innerHTML = getaDate(( 6 - datevalue));
      this.valueshowTarget.innerHTML = showaDate(( 6 - datevalue));
    }

    let enddate = this.valueTarget.innerHTML

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
    const news_url = window.location.href + `/news`
    let stock_news_url = `${news_url}?enddate=${enddate}`;
    let newsTurbo = document.querySelector('#news_stock')
    newsTurbo.src = stock_news_url
  }

}



// function replace(data){
//   let array = data["articles"]
//   let top7 = array.slice(0, 7)
//   let replacecontent = ''

//   top7.forEach(a => {
//     let newsdate = new Date(Date.parse(a["publishedAt"]))
//     replacecontent = replacecontent +
//     `<div class="font-serif">
//       <div class="my-4 p-4 border rounded-lg border-slate-300 hover:bg-gray-100 hover:cursor-pointer group" onclick="window.location='<%= a['url'] %>'">
//         <div class="flex items-center space-x-4">
//             <div class="flex-shrink-0">
//               <img class="object-cover h-20 w-20 rounded-xl" src="${a["urlToImage"]}" alt="news" >
//             </div>
//             <div class="flex flex-col h-20 justify-between">
//               <div>
//                 <a href="${a["url"]}" target="_blank">
//                   <p class="text-sm font-medium text-gray-900"
//                   style="display: -webkit-box; -webkit-box-orient: vertical;
//                   -webkit-line-clamp: 3; overflow: hidden;">
//                     ${a["title"]}
//                   </p>
//                 </a>
//               </div>
//               <div>
//                 <p class="text-sm text-gray-400 truncate">
//                   ${newsdate.toUTCString()}
//                 </p>
//               </div>
//             </div>
//         </div>
//       </div>
//     </div>`

//   });
//  return replacecontent
// }
