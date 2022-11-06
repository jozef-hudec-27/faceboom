class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @user = User.find_by id: params[:id]

    is_self = @user == current_user
    
    unless is_self
      is_friend = current_user.friends_with? @user
      @friend_request_status = current_user.friend_request_status_with @user
    end

    v = is_self ? 'Edit profile' : is_friend ? 'Remove Friend' : ['Send request', 'Cancel request', 'Accept request'][@friend_request_status]
    u = is_self ? edit_user_registration_path : is_friend ? 'unfriend url' : ['send request url', 'cancel request url', 'accept request url'][@friend_request_status]
    
    @profile_action_link = { value: v, url: u, method: is_self ? :get : :post }
  end
end
