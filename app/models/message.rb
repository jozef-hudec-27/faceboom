class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :chat

  has_one :notification, class_name: 'MessageNotification'

  validates :body, presence: true

  default_scope { order(:created_at) }

  after_create_commit :broadcast_message, :create_notification

  private

  def broadcast_message
    broadcast_append_later_to("chat_#{chat.key}",
      partial: 'messages/message',
      locals: { message: self },
      target: 'chat-messages'
    )

    broadcast_remove_to("chat_#{chat.key}", target: 'empty-chat-msg') 
  end

  def create_notification
    MessageNotification.create(message: self, receiver: chat.users.find { |u| u != sender })
  end
end
