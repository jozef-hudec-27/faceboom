import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['modal']

  showModal() {
    this.modalTarget.classList.add('is-active')
    document.querySelector('html').classList.add('is-clipped')
  }

  hideModal() {
    this.modalTarget.classList.remove('is-active')
    document.querySelector('html').classList.remove('is-clipped')
  }
}
