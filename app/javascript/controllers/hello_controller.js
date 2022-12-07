import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    this.element.textContent = "Hello World!"
  }
  // $(document).on('ajax:success', '.your-form', function(e, data) {
  //   if(data.status == 'success'){
  //     showSuccessFlash(data);
  //   }else{
  //     showErrorFlash(data);
  //   }
  // });
}
