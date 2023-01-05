class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = Message.new(body: params[:message]&.dig(:body), chat_id: params[:message]&.dig(:chat),
                           sender_id: current_user.id)

    respond_to do |format|
      if @message.save
        broadcast_dom_changes
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
                                                                       locals: { message: })
  end

  def read_all
    user = current_user.friends.find_by(id: params[:user_id])

    return unless (chat = Chat.between(current_user, user))

    unread_messages = chat.messages.where(sender: user, is_read: false)
    unread_messages.each { |message| message.update(is_read: true) }

    @last_message_notification = unread_messages.first&.notification

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { last_noti_id: @last_message_notification&.id } }
    end
  end

  private

  def broadcast_dom_changes
    if @message.receiver.online?
      UserChannel.broadcast_prepend_later_to("user-#{@message.receiver.id}", target: 'message-notifications-wrapper',
                                                                             partial: 'message_notifications/noti',
                                                                             locals: { noti: @message.notification,
                                                                                       session_cookie: faceboom_session })
    end

    return unless @message.receiver.online? && !@message.receiver.connected_to?(@message.chat)

    ActionCable.server.broadcast "user-#{@message.receiver.id}", { new_message: true }
  end
end
