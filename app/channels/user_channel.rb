class UserChannel < Turbo::StreamsChannel
  def subscribed
    ChannelSubscriptions.add 'UserChannel', current_user.id.to_s
    stream_from "user-#{current_user.id}"
  end

  def unsubscribed
    ChannelSubscriptions.remove 'UserChannel', current_user.id.to_s
  end
end
