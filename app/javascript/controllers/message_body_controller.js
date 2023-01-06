import { Controller } from "@hotwired/stimulus";

// Controller used to focus message input after sending a message
export default class extends Controller {
  static targets = ['input'];

  connect() {
    this.inputTarget.focus();
  };
};
