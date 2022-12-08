import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['bodyField', 'imageField', 'editButton', 'pickedFile']

  initialize() {
    this.originalBody = this.bodyFieldTarget.value
    this.originalPickedFileTextContent = this.pickedFileTarget.textContent.trim()
  }

  changeBody(e) {
    let validBody = (body) => body.split(' ').some(word => !!word) && body != this.originalBody
    let postBody = e.target.value 

    if (validBody(postBody) || (this.pickedFileTarget.textContent.trim())) {
      this.editButtonTarget.disabled = false
    } else {
      this.editButtonTarget.disabled = true
    }
  }

  restoreBody() {
    this.bodyFieldTarget.value = this.originalBody
    this.editButtonTarget.disabled = true
  }

  restoreImage() {
    this.imageFieldTarget.value = null
    this.pickedFileTarget.textContent = this.originalPickedFileTextContent
  }

  changePickedFile(e) {
    this.editButtonTarget.disabled = false
    this.pickedFileTarget.textContent = e.target.value.replace(/.*[\/\\]/, '')
  }

  toggleImagePicker() {
    this.imageFieldTarget.click()
  }

  updateOriginalAttributes() {
    this.originalBody = this.bodyFieldTarget.value
    this.originalPickedFileTextContent = this.imageFieldTarget.value ? 'Current image' : ''
  }
}
