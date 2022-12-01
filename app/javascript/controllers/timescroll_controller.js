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
      if(datevalue  === 7){
        this.valueTarget.innerHTML = new Date().toISOString().slice(0, 10);
      } else {
        this.valueTarget.innerHTML = getaDate(( 7 - datevalue));
      }
    });
  };
}
