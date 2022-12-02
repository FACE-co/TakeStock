import { Controller } from "@hotwired/stimulus";
// import flatpickr from "flatpickr";
// Connects to data-controller="timescroll"
export default class extends Controller {
  static targets = ["time", "value", "news"]

  connect() {
    console.log("timescroll connected");
    // flatpickr(this.timeTarget, {
    //   altInput: true
    // })
  };

  select() {
    const timerange = this.timeTarget.max
    this.timeTarget.addEventListener("click", e =>{
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
      if(datevalue  === timerange){
        this.valueTarget.innerHTML = new Date().toISOString().slice(0, 10);
      } else {
        this.valueTarget.innerHTML = getaDate(( timerange - datevalue));
      }
    });
    // changenews()

  };
  // changenews(){
  //   event.preventDefault()
  //   let enddate = this.valueTarget.innerHTML
  //   let ticker = this.tickernameTarget.innerText
  //   url = `https://newsapi.org/v2/everything?q=${ticker}&from=${enddate}&to=${enddate}&sortBy=popularity&apiKey=${ENV['NEWS_API_KEY']}`
  //   fetch(url, {
  //     method: "GET",
  //     headers: { "Accept": "application/json" },
  //     body: {??? }
  //   })
  //     .then(response => response.json())
  //     .then((data) => {
  //       console.log(data)
  //     })
  // }
}
