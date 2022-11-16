import { Controller } from '@hotwired/stimulus'
import Select2 from "select2"

export default class extends Controller {
  connect() {
    Select2()
    $('.js-select2').select2()
    $(document).on('select2:open', () => {
      document.querySelector('.select2-search__field').focus();
    });
  }
}

