class ApplicationController < ActionController::Base
  helper_method :unread_notifications, :latest_notifications
  helper_method :message_notifications, :unseen_message_notifications
  helper_method :faceboom_session

  protected

  def redirect_to_root_with_flash(message)
    flash[:alert] = message
    redirect_to root_path
  end

  def redirect_to_sign_in_with_flash(message)
    flash[:alert] = message
    redirect_to new_user_session_path
  end

  def unread_notifications
    current_user&.unread_notifications
  end

  def latest_notifications
    current_user&.latest_notifications
  end

  def message_notifications
    current_user&.received_message_notifications&.includes(:message, :sender)
  end

  def unseen_message_notifications
    current_user&.received_message_notifications&.unseen
  end

  def faceboom_session
    CGI.escape(cookies[:_faceboom_session] || '')
  end
end
