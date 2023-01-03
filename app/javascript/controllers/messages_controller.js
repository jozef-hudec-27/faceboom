import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ['messages'];
  static values = { fetchOlderMessagesLink: String }

  connect() {
    this.shouldScrollToBottom = true;
    this.currentMessagesPage = 1;

    // initially scroll the container to the bottom
    this.messagesTarget.scrollTop = this.messagesTarget.scrollHeight;

    const observer = new MutationObserver(() => {
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

  async fetchOlderMessages() {
    if (this.messagesTarget.scrollTop === 0) { // if the container is scrolled to top
      let olderMessagesResponse = await fetch(this.fetchOlderMessagesLinkValue + `?page=${this.currentMessagesPage+1}`);
      let olderMessages = await olderMessagesResponse.json();
      this.currentMessagesPage++;

      if (olderMessages.length > 0) {
        let prevHeight = this.messagesTarget.scrollHeight;
        this.friendAvatarImgSrc = this.friendAvatarImgSrc || document.querySelector('img.hover-shadow.rounded').src;

        olderMessages.reverse().forEach(message => {
          this.messagesTarget.innerHTML = this.messageHtmlString(message) + this.messagesTarget.innerHTML;
        });

        let heightDiff = this.messagesTarget.scrollHeight - prevHeight;
        this.messagesTarget.scrollTop = heightDiff; // reset scroll position
      };
    };
  };

  messageHtmlString(message) {
    return `<div class="chat-message-${message.sender.id}-wrapper flexbox" data-controller="modal">
              <div id="msg-${message.id}" class="chat-message-${message.sender.id} comment flex-align-end">
                  <img src="${this.friendAvatarImgSrc}">
          
                  <div class="flexbox flex-align-center gap-8">
                      ${message.is_removed ? '' : `
                      <button id="remove-msg-${message.id}-btn" class="button remove-msg-btn" data-action="modal#showModal">
                          <span class="icon is-small flexbox">
                              <i class="fa-solid fa-xmark"></i>
                          </span>
                      </button>
                      `}
          
                      <p class="chat-message-bubble comment-bubble tooltip" >
                          <span id="msg-${message.id}-body" class="${message.is_removed ?'removed' : ''}">
                              ${message.is_removed ? 'Message has been removed' : this.sanitizeHtml(message.body)}
                          </span>
          
                          <span class="tooltip-text-right flexbox flex-center">${message.time_since} ago</span>
                      </p>
                  </div>
              </div>
        
              <div class="message-remove-confirm-modal modal" data-modal-target="modal">
                  <div class="modal-background"></div>
                  <div class="modal-card">
                      <header class="modal-card-head">
                          <p class="modal-card-title">Remove message?</p>
                          <button class="delete" aria-label="close" data-action="modal#hideModal"></button>
                      </header>
          
                      <section class="modal-card-body">
                          <p>Do you really want to remove this message? Others in the chat may have already seen it.</p>
                      </section>
          
                      <footer class="modal-card-foot flexbox gap-8 flex-justify-end">
                          <button class="modal-btn-secondary" data-action="modal#hideModal">Cancel</button>
          
                          <a href="/messages/${message.id}" data-turbo-method="delete">
                              <button class="modal-btn-primary" tabindex="-1" data-action="modal#hideModal">Remove</button>
                          </a>
                      </footer>
                  </div>
              </div>
            </div>`;
  };

  sanitizeHtml(string) {
    return string.replace(/[^\w. ]/gi, c => '&#' + c.charCodeAt(0) + ';');
  };
};
