import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["flashes"]
  connect() {
    let fadeEffect = setInterval(function () {
      if (this.flashesTarget.style.opacity) {
          this.flashesTarget.style.opacity = 1;
      }
      if (this.flashesTarget.style.opacity > 0) {
          this.flashesTarget.style.opacity -= 0.1;
      } else {
          clearInterval(fadeEffect);
      }
  }, 200);
  }

}
