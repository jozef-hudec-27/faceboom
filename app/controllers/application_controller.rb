class ApplicationController < ActionController::Base
  helper_method :get_unread_notifications
  helper_method :get_latest_notifications
  
  protected
  
  def redirect_to_root_with_flash(message)
    flash[:alert] = message
    redirect_to root_path
  end

  def get_unread_notifications
    current_user&.unread_notifications
  end

  def get_latest_notifications
    current_user&.latest_notifications
  end
end
