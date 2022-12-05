# frozen_string_literal: true

class Users::PasswordsController < Devise::PasswordsController
  def new
    super
    render layout: 'instructions_page'
  end

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_reset_password_instructions_path_for(resource))
    else
      render :new, layout: 'instructions_page'
    end
  end

  def edit
    super
  end

  def update
    super
  end

  protected

  def after_resetting_password_path_for(resource)
    super(resource)
  end

  def after_sending_reset_password_instructions_path_for(resource)
    confirmation_string = resource.reset_password_sent_at.to_s.split(' ').join('')
    "#{mail_sent_user_path(resource)}?confirmation_string=#{confirmation_string}&mail_type=password_reset"
  end
end
