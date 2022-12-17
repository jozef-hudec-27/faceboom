class ChatsController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find_by id: params[:id]

    unless @chat = Chat.between(current_user, user)
      return redirect_to_root_with_flash('Chat not found.')
    end

    return redirect_to_root_with_flash('Chat not found.') unless @chat.is_active

    @other_user = @chat.users.find { |u| u != current_user }
    @show_close_btn = !params[:exit].nil?

    @messages = @chat.messages.includes(:sender)
    @message = @chat.messages.build
  end
end
