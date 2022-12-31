import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['input', 'inputHidden'];

  submit() {
    this.inputHiddenTarget.value = this.inputTarget.value.slice();
    this.inputTarget.value = '';
  };
};
