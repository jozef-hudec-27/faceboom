# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  def new
    super
  end

  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_resending_confirmation_instructions_path_for(resource))
    else
      respond_with resource
    end
  end

  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      set_flash_message!(:notice, :confirmed)

      DeviseMailer.with(user: resource).welcome.deliver_later

      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
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
