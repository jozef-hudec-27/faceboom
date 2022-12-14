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

  def email_changed(record, opts={})
    @user = record
    super
  end

  def welcome
    @user = params[:user]
    @provider = params[:provider]
    mail to: @user.email, subject: 'Welcome to Faceboom!', template_path: 'devise/mailer', template_name: 'welcome'
  end
end