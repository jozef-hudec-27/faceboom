class ApplicationController < ActionController::Base
  helper_method :get_unread_notifications, :get_latest_notifications
  helper_method :get_message_notifications, :get_unseen_message_notifications
  
  protected
  
  def redirect_to_root_with_flash(message)
    flash[:alert] = message
    redirect_to root_path
  end

  def redirect_to_sign_in_with_flash(message)
    flash[:alert] = message
    redirect_to new_user_session_path
  end

  def get_unread_notifications
    current_user&.unread_notifications
  end

  def get_latest_notifications
    current_user&.latest_notifications
  end

  def get_message_notifications
    current_user&.received_message_notifications.includes(:message, :sender)
  end

  def get_unseen_message_notifications
    current_user&.received_message_notifications.unseen
  end
end
