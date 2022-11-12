class Like < ApplicationRecord
  include Rails.application.routes.url_helpers

  belongs_to :user
  belongs_to :likeable, polymorphic: true

  after_create :create_like_notification

  private

  def create_like_notification
    notification_receiver = likeable.user
    return if user == notification_receiver

    Notification.create(sender: user,
                        receiver: notification_receiver,
                        text: "#{user.full_name} liked your #{likeable_type}.",
                        url: post_path(likeable_type == 'Post' ? likeable : likeable.root_post)
                      )
  end
end
