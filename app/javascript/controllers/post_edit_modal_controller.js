import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['body', 'image', 'submit', 'filePreview']

  initialize() {
    this.originalBody = this.bodyTarget.value
    this.originalfilePreviewTextContent = this.filePreviewTarget.textContent.trim()
  }

  changeBody(e) {
    let isValidBody = (body) => body.split(' ').some(word => !!word) && body != this.originalBody
    let postBody = e.target.value 

    if (isValidBody(postBody) || (this.filePreviewTarget.textContent.trim() && postBody != this.originalBody)) {
      this.enableSubmitButton()
    } else {
      this.disableSubmitButton()
    }
  }

  changeFilePreview(e) {
    this.filePreviewTarget.textContent = e.target.value.replace(/.*[\/\\]/, '')
    this.enableSubmitButton()
  }

  toggleImagePicker() {
    this.imageTarget.click()
  }

  updateOriginalAttributes() {
    this.originalBody = this.bodyTarget.value
    this.originalfilePreviewTextContent = this.imageTarget.value ? 'Current image' : ''
  }

  resetForm() {
    this.bodyTarget.value = this.originalBody
    this.imageTarget.value = null
    this.filePreviewTarget.textContent = this.originalfilePreviewTextContent
  }

  disableSubmitButton() {
    this.submitTarget.disabled = true
  }

  enableSubmitButton() {
    this.submitTarget.disabled = false
  }
}
