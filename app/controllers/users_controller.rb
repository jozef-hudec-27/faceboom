class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:mail_sent]
  before_action :unauthenicate_user!, only: [:mail_sent]

  def index
    @users = User.where.not(id: current_user.friend_ids + [current_user.id]).filter { |user| current_user.pending_friend_request_with(user).nil? }
  end

  def show
    @user = User.find_by id: params[:id]

    @is_self = @user == current_user
    
    unless @is_self
      is_friend = current_user.friends_with? @user
      @friend_request_status = current_user.friend_request_status_with @user

      url = is_friend ? unfriend_users_path : [friend_request_create_path, friend_request_cancel_path, friend_request_accept_path][@friend_request_status]
      obj_id = @friend_request_status.zero? ? @user.id : current_user.pending_friend_request_with(@user)&.id
      submit_text = is_friend ? 'Remove Friend' : ['Send request', 'Cancel request', 'Accept request'][@friend_request_status]
      
      @profile_action_data = { url: url, obj_id: obj_id, submit_text: submit_text }
    end

  end

  def unfriend
    user = User.find_by id: params[:id]

    return redirect_to_root_with_flash('User not found.') if user.nil?

    current_user.unfriend user
    redirect_back fallback_location: user_path(user)
  end

  def mail_sent
    @mail_type = params[:mail_type]

    unless ['confirmation', 'unlock', 'password_reset'].include? @mail_type
      flash[:alert] = 'Invalid action.'
      return redirect_back fallback_location: new_user_session_path
    end

    @user = User.find_by id: params[:id]

    if @mail_type == 'confirmation'
      confirmation_string = @user&.confirmation_sent_at.to_s.split(' ').join('')
    elsif @mail_type == 'unlock'
      confirmation_string = @user&.locked_at.to_s.split(' ').join('')
    elsif @mail_type == 'password_reset'
      confirmation_string = @user&.reset_password_sent_at.to_s.split(' ').join('')
    end

    if @user.nil? ||
       params[:confirmation_string] != confirmation_string ||
       (@mail_type == 'confirmation' && @user.confirmed?) ||
       (@mail_type == 'unlock' && !@user.access_locked?) ||
       (@mail_type == 'password_reset' && !@user.reset_password_period_valid?)
      return redirect_to_sign_in_with_flash('Invalid action.')
    end
  end

  private

  def unauthenicate_user!
    if user_signed_in?
      flash[:alert] = 'You are already signed in.'
      redirect_to root_path
    end
  end
end
