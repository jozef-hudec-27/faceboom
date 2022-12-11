class MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    @message = Message.new(body: params.dig(:message)&.dig(:body),
                           chat_id: params.dig(:message)&.dig(:chat),
                           sender_id: current_user.id
                          )
    if @message.save
      redirect_to chat_user_path(@message.chat.users.find { |u| u != current_user })
    else
      @chat = @message.chat
      @messages = @chat.messages
      render 'chats/show', status: :unprocessable_entity
    end
  end
end
