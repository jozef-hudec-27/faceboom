import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['modal'];

  findModal(caller) {
    if (this.modalTargets.length == 1) {
      return this.modalTarget;
    };

    return this.modalTargets.find(m => m.id == (caller.dataset.mdl || caller.parentNode.dataset.mdl));
  }

  showModal(e) {
    this.findModal(e.target).classList.add('is-active');
    document.querySelector('html').classList.add('is-clipped');
  };

  hideModal(e) {
    this.findModal(e.target).classList.remove('is-active');
    document.querySelector('html').classList.remove('is-clipped');
  };
};
