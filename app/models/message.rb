class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :chat

  validates :body, presence: true

  after_create_commit -> {
    broadcast_append_to('chat_',
                        partial: 'messages/message',
                        locals: { message: self },
                        target: 'chat-messages'
                      )
  }
end
