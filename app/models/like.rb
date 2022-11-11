class Like < ApplicationRecord
  belongs_to :user
  belongs_to :likeable, polymorphic: true

  after_create :create_like_notification

  private

  def create_like_notification
    Notification.create(sender: user,
                        receiver: likeable.user,
                        text: "#{sender.full_name} liked your #{likeable_type}.",
                        url: post_path(likeable_type == 'Post' ? likeable : likeable.root_post)
                      )
  end
end
