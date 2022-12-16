class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = Message.new(body: params.dig(:message)&.dig(:body),
                           chat_id: params.dig(:message)&.dig(:chat),
                           sender_id: current_user.id
                          )
    
    respond_to do |format|
      if @message.save
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('message_body', "<input autofocus='autofocus'
                                                                            required='required'
                                                                            autocomplete='body'
                                                                            class='input is-rounded'
                                                                            type='text'
                                                                            name='message[body]'
                                                                            id='message_body'
                                                                      >")
        end
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

    Turbo::StreamsChannel.broadcast_remove_to("chat_#{message.chat.key}", target: "remove-msg-#{message.id}-btn")
    Turbo::StreamsChannel.broadcast_replace_to("chat_#{message.chat.key}", target: "msg-#{message.id}-body",
                                                                           partial: 'messages/removed_msg_body',
                                                                           locals: { message: message }
                                              )
  end
end
