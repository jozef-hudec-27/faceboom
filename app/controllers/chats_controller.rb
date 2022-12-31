class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    @other_user = User.find_by id: params[:id]

    return redirect_to_root_with_flash('Chat not found.') unless (@chat = Chat.between(current_user, @other_user))

    return redirect_to_root_with_flash('Chat not found.') unless @chat.is_active

    @show_close_btn = !params[:exit].nil?

    @messages = @chat.messages.includes(:sender)
    @message = @chat.messages.build

    if params[:exit].nil?
      HTTP['X-CSRF-Token' => form_authenticity_token,
           'Cookie' => "_faceboom_session=#{faceboom_session}"].put messages_read_url(@other_user)
      HTTP['X-CSRF-Token' => form_authenticity_token,
           'Cookie' => "_faceboom_session=#{faceboom_session}"].put message_notifications_see_url(@other_user)
    end
  end
end
