import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['noti'];

  initialize() {
    setTimeout(() => {
      this.notiTarget.classList.add('live-msg-noti-fade-out');

      setTimeout(() => {
        this.notiTarget.remove();
      }, 750);
    }, 5000);
  };
};
