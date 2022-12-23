class MessageNotification < ApplicationRecord
  belongs_to :message
  belongs_to :receiver, class_name: 'User'
  has_one :sender, through: :message 

  scope :unseen, -> { where(seen: false) }
  scope :latest, -> { where('created_at > ?', Time.now - 7.days) }

  default_scope { order('created_at desc') }

  after_create_commit :destroy_previous_notification

  private

  def destroy_previous_notification
    prev_msg = Message.where(chat_id: message.chat.id, sender_id: sender.id).last(2)[0]
    prev_msg&.notification.destroy
  end
end
