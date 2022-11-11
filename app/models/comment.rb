class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  has_many :likes, as: :likeable, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  validates :body, presence: true

  after_create :create_comment_notification

  def root_post
    if commentable_type == 'Post'
      return commentable
    else
      return commentable.root_post
    end
  end

  private

  def create_comment_notification
    Notification.create(sender: user,
                        receiver: commentable.user,
                        text: "#{user.full_name} " + (commentable_type == 'Post' ? 'commented on your post.' : 'replied to your comment.'),
                        url: post_path(commentable_type == 'Post' ? commentable : commentable.root_post)
                      )
  end
end
