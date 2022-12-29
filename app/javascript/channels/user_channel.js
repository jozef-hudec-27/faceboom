import consumer from "channels/consumer";

consumer.subscriptions.create("UserChannel", {
  received(data) {
    console.log(data);
  }
});
