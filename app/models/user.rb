class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable
  devise :omniauthable, omniauth_providers: %i[facebook]
  validates :first_name, :last_name, presence: true

  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id', dependent: :destroy
  has_many :sent_notifications, class_name: 'Notification', foreign_key: 'sender_id', dependent: :destroy
  has_many :received_notifications, class_name: 'Notification', foreign_key: 'receiver_id', dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :sent_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_and_belongs_to_many :friends, class_name: 'User',
                                    join_table: :friendships,
                                    foreign_key: :user_id,
                                    association_foreign_key: :friend_user_id 
  has_and_belongs_to_many :saved_posts, class_name: 'Post', join_table: :saved_posts
                            
  has_one_attached :avatar

  before_create :attach_default_avatar

  def self.from_omniauth(auth)
    where(email: auth.info.email).first_or_initialize do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.first_name = auth.info.name.split(' ')[0]
      user.last_name = auth.info.name.split(' ')[1]
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.skip_confirmation!
      user.save!
      DeviseMailer.with(user: user, provider: auth.provider).welcome.deliver_later
    end
  end

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
    Chat.between(self, user).update is_active: false
  end

  def unread_notifications
    received_notifications.where read: false
  end

  def latest_notifications
    received_notifications.latest
  end

  def confirm(args = {})
    pending_any_confirmation do
      if confirmation_period_expired?
        self.errors.add(:email, :confirmation_period_expired,
          period: Devise::TimeInflector.time_ago_in_words(self.class.confirm_within.ago))
        return false
      end

      unconfirmed_email_address = unconfirmed_email

      self.confirmed_at = Time.now.utc

      saved = if pending_reconfirmation?
        skip_reconfirmation!
        self.email = unconfirmed_email
        self.unconfirmed_email = nil

        save(validate: true)
      else
        save(validate: args[:ensure_valid] == true)
      end

      after_confirmation(unconfirmed_email_address) if saved
      saved
    end
  end

  protected

  def after_confirmation(prev_unconfirmed_email)
    DeviseMailer.with(user: self).welcome.deliver_later unless prev_unconfirmed_email
  end

  private

  def attach_default_avatar
    self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default-avatar.svg')),
                       filename: 'default-avatar.svg',
                       content_type: 'image/svg+xml'
                      )
  end
end
