class FriendRequestsController < ApplicationController
  before_action :authenticate_user!

  def create
    receiver = User.find_by id: params[:id]

    return redirect_to_root_with_flash('Invalid user.') if receiver.nil? || receiver == current_user || current_user.friends_with?(receiver)
    return redirect_to_root_with_flash('Friend request already sent.') if current_user.pending_friend_request_with receiver

    current_user.send_friend_request_to receiver
    
    respond_to do |format|
      if params[:respond_format] == 'turbo-stream'
        format.turbo_stream { render turbo_stream: turbo_stream.remove("user-#{receiver.id}") }
      else
        flash[:notice] = "Successfully sent friend request to #{receiver.full_name}."
        format.html { redirect_back(fallback_location: user_path(receiver)) }
      end
    end
  end

  def cancel
    request = FriendRequest.find_by id: params[:id]
    receiver = request.receiver

    return redirect_to_root_with_flash('Request not found.') if request.nil?
    
    request.destroy
    flash[:notice] = "Successfully canceled friend request to #{receiver.full_name}."
    redirect_back(fallback_location: user_path(receiver))
  end

  def accept
    request = FriendRequest.find_by id: params[:id]
    sender = request.sender

    return redirect_to_root_with_flash('Request not found.') if request.nil?

    request.accept
    flash[:notice] = "You are now friends with #{sender.full_name}."
    redirect_back(fallback_location: user_path(sender))
  end

  def reject
    request = FriendRequest.find_by id: params[:id]
    sender = request.sender

    return redirect_to_root_with_flash('Request not found.') if request.nil?

    request.reject
    flash[:notice] = "Rejected #{sender.full_name}'s friend request."
    redirect_back(fallback_location: user_path(sender))
  end
end
