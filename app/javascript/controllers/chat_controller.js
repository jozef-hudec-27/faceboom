import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static values = { readMessagesLink: String, sessionCookie: String, seeMsgNotificationsLink: String };

  initialize() {
    this.requestHeaders = {
      'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
      'Cookie': `_faceboom_session=${this.sessionCookieValue}`
    };
  };

  async readUnreadMessages() {
    let requestOptions = { method: 'PUT', headers: this.requestHeaders };

    let response = await fetch(this.readMessagesLinkValue, requestOptions);
    let data = await response.json();

    if (data.last_noti_id) { 
      this.removeUnreadStyles(data.last_noti_id);
    };
  };

  removeUnreadStyles(notiId) {
    document.getElementById(`msg-noti-${notiId}-sender`).classList.remove('bold');
    document.getElementById(`msg-noti-${notiId}-body`).style = 'line-height: 1em;';
    document.getElementById(`msg-noti-${notiId}-dot`).remove();
  }

  async seeMsgNotifications() {
    let requestOptions = { method: 'PUT', headers: this.requestHeaders };

    let response = await fetch(this.seeMsgNotificationsLinkValue, requestOptions);
    let data = await response.json();

    if (data.update) {
      document.getElementById('message-notifications-btn').classList.remove('has-text-danger');
    };
  };
};
