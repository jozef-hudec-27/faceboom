class MessageNotificationsController < ApplicationController
  before_action :authenticate_user!

  def mark_all_seen
    message_notifications = current_user.received_message_notifications.unseen

    message_notifications.each { |noti| noti.update seen: true }

    respond_to { |format| format.turbo_stream }
  end

  def mark_seen
    user = current_user.friends.find_by(id: params[:user_id])

    return unless (chat = Chat.between(current_user, user))

    message = chat.messages.where(sender: user).first

    message&.notification&.update seen: true

    respond_to do |format|
      format.turbo_stream
      format.json { render json: { update: unseen_message_notifications.empty? } }
    end
  end
end
