# class UserChannel < ApplicationCable::Channel
#   extend Turbo::Streams::Broadcasts, Turbo::Streams::StreamName
class UserChannel < Turbo::StreamsChannel
  def subscribed
    stream_from "user-#{current_user.id}"
  end
end
