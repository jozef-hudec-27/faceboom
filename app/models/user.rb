class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable
  validates :first_name, :last_name, presence: true

  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id'
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id'
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id'
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'receiver_id'
  has_many :posts
  has_many :likes
  has_many :comments
  has_and_belongs_to_many :friends, class_name: 'User',
                                    join_table: :friendships,
                                    foreign_key: :user_id,
                                    association_foreign_key: :friend_user_id 
                            
  has_one_attached :avatar

  before_create :attach_default_avatar

  def full_name
    "#{first_name} #{last_name}"
  end

  def friends_with?(user)
    !friends.find_by(id: user.id).nil?
  end

  def send_friend_request_to(user)
    FriendRequest.create sender: self, receiver: user
  end

  def pending_friend_request_with(user)
    FriendRequest.find_by(sender: self, receiver: user) || FriendRequest.find_by(sender: user, receiver: self)
  end

  def friend_request_status_with(user)
    # 0 - no requests sent
    # 1 - we sent them
    # 2 - they sent us

    FriendRequest.find_by(sender: self, receiver: user) ? 1 : FriendRequest.find_by(sender: user, receiver: self) ? 2 : 0
  end

  def unfriend(user)
    friends.delete user
    user.friends.delete self
  end

  def unread_notifications
    Notification.where receiver: self, read: false
  end

  def latest_notifications
    Notification.latest.where receiver: self
  end

  private

  def attach_default_avatar
    self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default-avatar.svg')),
                       filename: 'default-avatar.svg',
                       content_type: 'image/svg+xml'
                      )
  end
end
