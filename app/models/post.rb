class Post < ApplicationRecord
  paginates_per 3

  validates :body, presence: { message: 'or image must be given.' }, unless: ->(post) { post.image.present? }
  validates :image, presence: { message: 'or body must be given.' }, unless: ->(post) { post.body.present? }
  validate :acceptable_image

  belongs_to :user
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_one_attached :image

  default_scope { order('created_at desc') }

  def self.posts_for(user)
    where user: [user] + user.friends
  end

  def liked_by?(user)
    likes.where(user:).exists?
  end

  def saved_by?(user)
    !user.saved_posts.find_by(id:).nil?
  end

  def all_comments_count(post_comments = nil)
    post_comments = comments if post_comments.nil?
    q = post_comments.to_a
    count = 0

    until q.empty?
      count += 1
      q += q.shift.comments.to_a
    end

    count
  end

  private

  def acceptable_image
    return unless image.attached?

    unless image.byte_size <= 5.megabyte
      errors.add :image, 'is too big'
    end

    acceptable_types = ['image/jpeg', 'image/png']
    unless acceptable_types.include? image.content_type
      errors.add :image, 'must be a JPEG or PNG'
    end
  end
end
