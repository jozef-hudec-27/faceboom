import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['fileInput', 'fileNameContainer']

  pasteFilename() {
    if (this.fileInputTarget.files.length > 0) {
      this.fileNameContainerTarget.textContent = this.fileInputTarget.files[0].name
    }
  }
}
