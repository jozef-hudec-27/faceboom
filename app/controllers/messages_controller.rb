class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = Message.new(body: params.dig(:message)&.dig(:body),
                           chat_id: params.dig(:message)&.dig(:chat),
                           sender_id: current_user.id)
    
    respond_to do |format|
      if @message.save
        receiver = @message.chat.users.find { |u| u != current_user }

        if ChannelSubscriptions.connected?("#{receiver.id}-chat_#{@message.chat.key}")
          @message.update is_read: true
          @message.notification.update seen: true
        end

        format.turbo_stream
      else
        @chat = @message.chat
        @messages = @chat.messages
        format.html { render 'chats/show', status: :unprocessable_entity }
      end
    end
  end

  def destroy
    message = current_user.sent_messages.find_by id: params[:id]

    return if message.nil?

    message.update is_removed: true

    ChatChannel.broadcast_remove_to("chat_#{message.chat.key}", target: "remove-msg-#{message.id}-btn")
    ChatChannel.broadcast_replace_later_to("chat_#{message.chat.key}", target: "msg-#{message.id}-body",
                                                                            partial: 'messages/removed_msg_body',
                                                                            locals: { message: message }
                                              )
  end

  def read_all
    user = current_user.friends.find_by(id: params[:user_id])

    return unless chat = Chat.between(current_user, user)

    unread_messages = chat.messages.where(sender: user, is_read: false)
    unread_messages.each { |message| message.update(is_read: true) } 

    @last_message_notification = unread_messages.last&.notification

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { last_noti_id: @last_message_notification&.id } }
    end
  end
end
