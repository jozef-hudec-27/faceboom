class FriendRequest < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  after_create :create_friend_request_notification

  def accept
    sender.friends << receiver
    receiver.friends << sender
    destroy
    Notification.create sender: receiver, receiver: sender,
                        text: "#{receiver.full_name} accepted your friend request.", url: user_path(receiver)

    if chat = Chat.between(sender, receiver)
      chat.update is_active: true
    else
      ids = [sender.id, receiver.id].sort
      Chat.create key: "#{ids[0]}u_#{ids[1]}u"
    end
  end

  def reject
    destroy
  end

  private

  def create_friend_request_notification
    Notification.create(sender:,
                        receiver:,
                        text: "#{sender.full_name} sent you a friend request.",
                        url: user_path(sender))
  end
end
