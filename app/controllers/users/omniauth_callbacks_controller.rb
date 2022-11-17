# frozen_string_literal: true

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    auth = request.env["omniauth.auth"]

    return redirect_to_sign_in_with_flash('Please, grant permission to your email address.
                                           You need to remove our app from your Facebook account and do this again.') unless auth.info.include?(:email)

    @user = User.from_omniauth(auth)

    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = auth.except(:extra) 
      redirect_to new_user_registration_url
    end
  end

  def failure
    redirect_to root_path
  end
end
