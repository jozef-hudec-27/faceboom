# frozen_string_literal: true

class Users::UnlocksController < Devise::UnlocksController
  def new
    super
  end

  def create
    self.resource = resource_class.send_unlock_instructions(resource_params)
    yield resource if block_given?

    if successfully_sent?(resource)
      respond_with({}, location: after_sending_unlock_instructions_path_for(resource))
    else
      respond_with resource
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
