class Comment < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  after_create :create_comment_notification

  default_scope { order('created_at desc') }

  def liked_by?(user)
    likes.where(user:).exists?
  end

  def root_post
    if commentable_type == 'Post'
      commentable
    else
      commentable.root_post
    end
  end

  private

  def create_comment_notification
    notification_receiver = commentable.user
    return if user == notification_receiver

    Notification.create(sender: user,
                        receiver: notification_receiver,
                        text: "#{user.full_name} " + (commentable_type == 'Post' ? 'commented on your post.' : 'replied to your comment.'),
                        url: post_path(commentable_type == 'Post' ? commentable : commentable.root_post))
  end
end
