class ChatChannel < Turbo::StreamsChannel
  def subscribed
    if stream_name = verified_stream_name_from_params
      stream_from stream_name
      ChannelSubscriptions.add "#{current_user.id}-#{stream_name}"
    else
      reject
    end
  end

  def unsubscribed
    ChannelSubscriptions.remove "#{current_user.id}-#{verified_stream_name_from_params}"
    super
  end
end
