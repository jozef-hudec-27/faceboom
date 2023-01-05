import consumer from "channels/consumer";

consumer.subscriptions.create("UserChannel", {
  received(data) {
    if (data.new_message) { // we're online but not connected to the chat
      document.getElementById('msg-noti-sound').play();
      document.getElementById('message-notifications-btn').classList.add('has-text-danger');
    };
  }
});
