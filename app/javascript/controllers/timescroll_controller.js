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
    this.timeTarget.addEventListener("click", e =>{
      let date = this.timeTarget.value
      function getaDate(i) {
        let dateToday = new Date();
        dateToday.setDate(dateToday.getDate() - i);
        return dateToday.getFullYear() + '-' + (dateToday.getMonth()+1) + '-' + dateToday.getDate();
    }
      if(date == 7){
        this.valueTarget.innerHTML = new Date().toISOString().slice(0, 10);
      } else {
        this.valueTarget.innerHTML = getaDate((7-date));
      }
    });
  };
}
