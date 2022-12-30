import consumer from "channels/consumer";

consumer.subscriptions.create("UserChannel", {
  received(data) {
    if (typeof data == 'object') { // we're online but not connected to the chat
      document.getElementById('message-notifications-btn').classList.add('has-text-danger')
    }
  }
});
