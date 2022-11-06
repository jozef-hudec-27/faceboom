class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @user = User.find_by id: params[:id]

    @is_self = @user == current_user
    
    unless @is_self
      is_friend = current_user.friends_with? @user
      @friend_request_status = current_user.friend_request_status_with @user

      url = is_friend ? unfriend_users_path : ['send request url', 'cancel request url', 'accept request url'][@friend_request_status]
      obj_id = is_friend ? @user.id : current_user.pending_friend_request_with(@user)&.id
      submit_text = is_friend ? 'Remove Friend' : ['Send request', 'Cancel request', 'Accept request'][@friend_request_status]
      
      @profile_action_data = { url: url, obj_id: obj_id, submit_text: submit_text }
    end

  end

  def unfriend
    user = User.find_by id: params[:id]

    return redirect_to_root_with_flash('User not found.') if user.nil?

    current_user.unfriend user
    redirect_to user
  end
end
