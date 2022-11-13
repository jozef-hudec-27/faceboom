class DeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    @user = record
    super
  end

  def unlock_instructions(record, token, opts={})
    @user = record
    super
  end

  def reset_password_instructions(record, token, opts={})
    @user = record
    super
  end
end