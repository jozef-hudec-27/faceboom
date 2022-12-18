class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    @receiver = User.find_by id: params[:id]

    return redirect_to_root_with_flash('Invalid user.') if @receiver.nil? || @receiver == current_user || current_user.friends_with?(@receiver)
    return redirect_to_root_with_flash('Friend request already sent.') if current_user.pending_friend_request_with @receiver

    current_user.send_friend_request_to @receiver
    
    respond_to do |format|
      if params[:respond_format] == 'turbo-stream'
        format.turbo_stream 
      else
        format.html { redirect_back(fallback_location: user_path(@receiver)) }
      end
    end
  end

  def cancel
    request = FriendRequest.find_by id: params[:id]
    @receiver = request.receiver

    return redirect_to_root_with_flash('Request not found.') if request.nil?
    
    request.destroy

    respond_to do |format|
      if params[:respond_format] == 'turbo-stream'
        @profile_action_btn_partial_locals = {
          submit_btn_style: 'light-blue-btn px-12 py-2', respond_format: 'turbo-stream',
          is_self: false, friend_request_status: 0,
          profile_action_data: { url: friend_request_create_path, obj_id: @receiver.id, submit_text: 'Send request' }
        }

        format.turbo_stream
      else
        format.html { redirect_back(fallback_location: user_path(@receiver)) }
      end
    end
  end

  def accept
    request = FriendRequest.find_by id: params[:id]
    @sender = request.sender

    return redirect_to_root_with_flash('Request not found.') if request.nil?

    request.accept
    
    respond_to do |format|
      if params[:respond_format] == 'turbo-stream'
        format.turbo_stream
      else
        flash[:notice] = "You are now friends with #{@sender.full_name}."
        format.html { redirect_back(fallback_location: user_path(@sender)) }
      end
    end
  end

  def reject
    request = FriendRequest.find_by id: params[:id]
    @sender = request.sender

    return redirect_to_root_with_flash('Request not found.') if request.nil?

    request.reject

    respond_to do |format|
      if params[:respond_format] == 'turbo-stream'
        @profile_action_btn_partial_locals = {
          submit_btn_style: 'light-blue-btn px-12 py-2', respond_format: 'turbo-stream',
          is_self: false, friend_request_status: 0,
          profile_action_data: { url: friend_request_create_path, obj_id: @sender.id, submit_text: 'Send request' }
        }

        format.turbo_stream
      else
        format.html { redirect_back fallback_location: user_path(@sender) }
      end
    end
  end
end
