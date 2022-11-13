# frozen_string_literal: true

class Users::UnlocksController < Devise::UnlocksController
  def new
    super
  end

  def create
    return redirect_to_sign_in_with_flash('User does not exist.') unless User.find_by email: params.dig(:user).dig(:email)

    self.resource = resource_class.send_unlock_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_unlock_instructions_path_for(resource))
    else
      flash[:alert] = 'Could not send unlock account email.'
      redirect_to new_user_session_path
    end
  end

  def show
    super
  end

  protected

  def after_sending_unlock_instructions_path_for(resource)
    confirmation_string = resource.locked_at.to_s.split(' ').join('')
    "#{mail_sent_user_path(resource)}?confirmation_string=#{confirmation_string}&mail_type=unlock"
  end

  def after_unlock_path_for(resource)
    super(resource)
  end
end
