import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['tabButton', 'tabContainer']

  changeTab(e) {
    e.target.parentNode.classList.add('is-active')
    let tabContainerId = e.target.dataset['containerId']

    this.tabButtonTargets.forEach(node => {
      if (node != e.target) {
        node.parentNode.classList.remove('is-active')
      }
    })

    this.tabContainerTargets.forEach(container => {
      console.log(container.id, tabContainerId)

      if (container.id != tabContainerId) {
        container.hidden = true
      } else {
        container.hidden = false
      }
    })
  }
}
