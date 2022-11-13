# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  def create
    return redirect_to_sign_in_with_flash('User does not exist.') unless User.find_by email: params.dig(:user).dig(:email)

    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource))
    else
      flash[:alert] = 'Could not send confirmation email.'
      redirect_to new_user_session_path
    end
  end

  def show
    super
  end

  protected

  def after_resending_confirmation_instructions_path_for(resource)
    confirmation_string = resource.confirmation_sent_at.to_s.split(' ').join('')
    "#{mail_sent_user_path(resource)}?confirmation_string=#{confirmation_string}&mail_type=confirmation"
  end

  def after_confirmation_path_for(resource_name, resource)
    super(resource_name, resource)
  end
end
