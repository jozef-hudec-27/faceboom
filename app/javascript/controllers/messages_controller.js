import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['messages'];

  connect() {
    this.shouldScrollToBottom = true;

    // initially scroll the container to the bottom
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;

    const observer = new MutationObserver(() => {
      console.log(this.shouldScrollToBottom )
      if (this.shouldScrollToBottom) {
        this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight; 
      };
    });
    observer.observe(this.messagesTarget, { childList: true });
  };

  updateShouldScroll() {
    if (this.messagesTarget.scrollTop + this.messagesTarget.clientHeight > this.messagesTarget.scrollHeight - 10) {
      this.shouldScrollToBottom = true;
    } else {
      this.shouldScrollToBottom = false;
    };
  };
};
