import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['container']

  hideNotification() {
    this.containerTarget.hidden = true
  }
}
