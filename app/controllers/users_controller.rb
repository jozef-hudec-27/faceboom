class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
  end

  def show
    @user = User.find_by id: params[:id]
  end

  def edit
  end

  def update
  end
end
