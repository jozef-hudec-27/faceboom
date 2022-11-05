class ApplicationController < ActionController::Base
  protected

  def redirect_to_root_with_flash(message)
    flash[:alert] = message
    redirect_to root_path
  end
end
