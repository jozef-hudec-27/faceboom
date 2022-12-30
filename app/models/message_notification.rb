class MessageNotification < ApplicationRecord
  belongs_to :message
  belongs_to :receiver, class_name: 'User'
  has_one :sender, through: :message 

  scope :unseen, -> { where(seen: false) }
  scope :latest, -> { where('created_at > ?', Time.now - 7.days) }

  default_scope { order('created_at desc') }

  after_create_commit do
    remove_prev_noti_from_dom if receiver.online?
    destroy_previous_notification
    display_push_notification if receiver.online? && !receiver.connected_to?(message.chat)
  end

  private

  def destroy_previous_notification
    prev_msg = Message.where(chat_id: message.chat.id, sender_id: sender.id).last(2)[0]
    prev_msg&.notification&.destroy
  end

  def remove_prev_noti_from_dom
    prev_msg = message.chat.messages.where(sender: sender).where.not(id: message.id).last
    UserChannel.broadcast_remove_to("user-#{receiver.id}", target: "msg-noti-#{prev_msg.notification.id}") if prev_msg&.notification
  end

  def display_push_notification
    UserChannel.broadcast_prepend_later_to("user-#{receiver.id}", target: 'msg-noti-container',
                                          partial: 'message_notifications/live_noti',
                                          locals: { noti: self }
    )
  end
end
