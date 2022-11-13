class DeviseMailer < Devise::Mailer
  def confirmation_instructions(record, token, opts={})
    @user = record
    super
  end
end