class Post < ApplicationRecord
  validates :body, :image, presence: true

  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_one_attached :image

  default_scope { order('created_at desc') }

  def self.posts_for(user)
    where(user: [user] + user.friends)
  end
end
