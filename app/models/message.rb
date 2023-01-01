class Message < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :chat

  has_one :notification, class_name: 'MessageNotification'
  has_one :receiver, through: :notification

  validates :body, presence: true

  default_scope { order(:created_at) }

  after_create_commit do
    broadcast_message
    create_notification

    read_message if receiver.connected_to? chat
  end

  private

  def broadcast_message
    ChatChannel.broadcast_append_later_to("chat_#{chat.key}",
                                          partial: 'messages/message',
                                          locals: { message: self },
                                          target: 'chat-messages')

    ChatChannel.broadcast_remove_to("chat_#{chat.key}", target: 'empty-chat-msg')
  end

  def create_notification
    MessageNotification.create(
      message: self,
      receiver: chat.users.find { |u| u != sender },
      seen: is_read
    )
  end

  def read_message
    update is_read: true
    notification.update seen: true
  end
end
