class UsersController < ApplicationController
  before_action :authenticate_user!, except: [:mail_sent, :privacy_policy]
  before_action :unauthenicate_user!, only: [:mail_sent]

  def index
    query = params[:q]&.downcase || ''
    @users = []
    User.where('LOWER(first_name) LIKE ? OR LOWER(last_name) LIKE ?', "%#{User.sanitize_sql_like(query)}%",
               "%#{User.sanitize_sql_like(query)}%")
        .where.not(id: current_user.id).each do |user|
      @users << data_for(user)
    end
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

      @profile_action_data = { url:, obj_id:, submit_text: }
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

    unless %w[confirmation unlock password_reset].include? @mail_type
      flash[:alert] = 'Invalid action.'
      return redirect_back fallback_location: new_user_session_path
    end

    @user = User.find_by id: params[:id]

    mail_type_hash = {
      'confirmation' => @user&.confirmation_sent_at.to_s.split(' ').join(''),
      'unlock' => @user&.locked_at.to_s.split(' ').join(''),
      'password_reset' => @user&.reset_password_sent_at.to_s.split(' ').join('')
    }
    confirmation_string = mail_type_hash[@mail_type]

    if @user.nil? ||
       params[:confirmation_string] != confirmation_string ||
       (@mail_type == 'confirmation' && @user.confirmed?) ||
       (@mail_type == 'unlock' && !@user.access_locked?) ||
       (@mail_type == 'password_reset' && !@user.reset_password_period_valid?)
      redirect_to_sign_in_with_flash('Invalid action.')
    end
  end

  def privacy_policy; end

  private

  def unauthenicate_user!
    return unless user_signed_in?

    flash[:alert] = 'You are already signed in.'
    redirect_to root_path
  end

  def data_for(user)
    is_friend = current_user.friends_with?(user)
    request_status = current_user.friend_request_status_with(user)
    profile_action_data = {
      url: is_friend ? nil : [friend_request_create_path, friend_request_cancel_path, friend_request_accept_path][request_status],
      submit_text: is_friend ? nil : ['Send request', 'Cancel request', 'Accept request'][request_status],
      obj_id: if is_friend
                nil
              else
                request_status.zero? ? user.id : current_user.pending_friend_request_with(user)&.id
              end
    }

    [user, request_status, is_friend, profile_action_data]
  end
end
