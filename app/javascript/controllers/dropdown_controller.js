import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['main'];

  showDropdown() {
    this.mainTarget.classList.toggle('is-active');
  };
};
