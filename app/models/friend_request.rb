class FriendRequest < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  def accept
    sender.friends << receiver
    receiver.friends << sender
    destroy
  end

  def reject
    destroy
  end
end
