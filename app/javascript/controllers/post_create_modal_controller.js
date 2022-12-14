import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['image', 'body', 'submit', 'filePreview', 'imageCopy', 'bodyCopy', 'bodyPreview'];

  toggleImagePicker() {
    this.imageTarget.click();
  };

  changeBody(e) {
    let isValidBody = (body) => body.split(' ').some(word => !!word);
    let postBody = e.target.value ;

    if (isValidBody(postBody) || this.imageTarget.value) {
      this.enableSubmitButton();
    } else {
      this.disableSubmitButton();
    };
  }

  changeFilePreview(e) {
    this.enableSubmitButton();
    this.filePreviewTarget.textContent = e.target.value.replace(/.*[\/\\]/, '');
  };

  resetForm() {
    this.bodyCopyTarget.value = this.bodyTarget.value.slice();
    this.bodyTarget.value = '';

    document.getElementById('post_image_clone')?.remove();
    let imageTargetClone = this.imageTarget.cloneNode();
    this.imageTarget.value = '';
    imageTargetClone.id = 'post_image_clone';
    this.imageTarget.parentNode.appendChild(imageTargetClone);
  };

  copyBody() {
    this.bodyPreviewTarget.value = this.bodyTarget.value.slice();
  };

  disableSubmitButton() {
    this.submitTarget.disabled = true;
  };

  enableSubmitButton() {
    this.submitTarget.disabled = false;
  };
};
