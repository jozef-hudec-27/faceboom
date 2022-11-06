class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable
  validates :first_name, :last_name, presence: true

  has_many :sent_friend_requests, class_name: 'FriendRequest', foreign_key: 'sender_id'
  has_many :received_friend_requests, class_name: 'FriendRequest', foreign_key: 'receiver_id'
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

  private

  def attach_default_avatar
    self.avatar.attach(io: File.open(Rails.root.join('app', 'assets', 'images', 'default-avatar.svg')),
                       filename: 'default-avatar.svg',
                       content_type: 'image/svg+xml'
                      )
  end
end
