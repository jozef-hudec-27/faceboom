import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['imageField', 'bodyField', 'postButton', 'pickedFile', 'imageFieldCopy', 'bodyFieldCopy']

  toggleImagePicker() {
    this.imageFieldTarget.click()
  }

  changeBody(e) {
    let validBody = (body) => body.split(' ').some(word => !!word)
    let postBody = e.target.value 

    if (validBody(postBody) || this.imageFieldTarget.value) {
      this.postButtonTarget.disabled = false
    } else {
      this.postButtonTarget.disabled = true
    }
  }

  displayPickedFile(e) {
    this.postButtonTarget.disabled = false
    this.pickedFileTarget.textContent = e.target.value.replace(/.*[\/\\]/, '')
  }

  resetForm() {
    this.bodyFieldCopyTarget.value = this.bodyFieldTarget.value.slice()
    this.bodyFieldTarget.value = ''

    this.imageFieldCopyTarget.value = this.imageFieldTarget.value
    this.imageFieldTarget.value = null
  }
}
