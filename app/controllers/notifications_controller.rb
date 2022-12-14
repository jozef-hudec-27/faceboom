class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @new_notifications = current_user.latest_notifications
    @unread_notifications = current_user.unread_notifications
  end

  def read
    notification = current_user.unread_notifications.find_by(id: params[:id]) ||
                   current_user.received_notifications.find_by(id: params[:id])

    return redirect_to_root_with_flash('Notification does not exist.') if notification.nil?

    notification.update read: true
    redirect_to notification.url
  end

  def read_all
    notifications = current_user.unread_notifications

    notifications.each do |notification|
      notification.update read: true
    end

    respond_to { |format| format.turbo_stream }
  end
end
