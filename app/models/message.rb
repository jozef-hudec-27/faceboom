class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :chat

  has_one :message_notification

  validates :body, presence: true

  default_scope { order(:created_at) }

    after_create_commit -> {
    broadcast_append_to("chat_#{chat.key}",
                        partial: 'messages/message',
                        locals: { message: self },
                        target: 'chat-messages'
                      )

    broadcast_remove_to("chat_#{chat.key}", target: 'empty-chat-msg') 
  }
end
