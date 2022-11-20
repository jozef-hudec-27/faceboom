class Post < ApplicationRecord
  validates :body, presence: { message: "or image must be given." }, unless: ->(post) { post.image.present? }
  validates :image, presence: { message: "or body must be given." }, unless: ->(post) { post.body.present? }

  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_one_attached :image

  default_scope { order('created_at desc') }

  def self.posts_for(user)
    where user: [user] + user.friends
  end

  def liked_by?(user)
    likes.where(user: user).exists?
  end
end
