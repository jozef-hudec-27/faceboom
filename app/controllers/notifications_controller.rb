class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @new_notifications = current_user.latest_notifications 
    @unread_notifications = current_user.unread_notifications
  end
end
