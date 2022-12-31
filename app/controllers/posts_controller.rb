class PostsController < ApplicationController
  include ActiveStorage::SetCurrent

  before_action :authenticate_user!

  def index
    @posts = Post.posts_for(current_user).page(params[:page] || 1).includes(:user)
    @first_page = params[:page].nil? || params[:page] == '1'
    @is_turbo_frame_request = !params[:t].nil?
  end

  def show
    @post = Post.find_by id: params[:id]

    return redirect_to_root_with_flash('Post not found.') if @post.nil?

    @comments = @post.comments.includes :user, :likes, :comments
    @comment = Comment.new

    render layout: 'basic'
  end

  def create
    params[:post] = params[:post].except(:image) if params[:post][:image] == ''

    @post = current_user.posts.build post_params

    respond_to do |format|
      if @post.save
        format.turbo_stream
      else
        flash[:alert] = 'Post must have at least body or image!'
        format.html { redirect_to root_path }
      end
    end
  end

  def destroy
    post = current_user.posts.find_by id: params[:id]

    return redirect_to_root_with_flash("You don't have permission to do this.") if post.nil?

    post.destroy

    respond_to do |format|
      if request.referer&.include? post_path(post) # we came from post detail page
        flash[:notice] = 'Successfully deleted post.'
        format.html { redirect_to root_path }
      else
        format.turbo_stream { render turbo_stream: turbo_stream.remove("post-#{post.id}") }
      end
    end
  end

  def update
    @post = current_user.posts.find_by id: params[:id]

    return redirect_to_root_with_flash("You don't have permissions to do this.") if @post.nil?
    return redirect_to_root_with_flash('Invalid action.') if params[:post].nil?

    @post.image.attach(params[:post][:image]) unless params[:post][:image].nil?

    respond_to do |format|
      if @post.update(body: params[:post][:body])
        format.turbo_stream
      else
        flash[:alert] = 'Could not edit post.'
        redirect_to root_path
      end
    end
  end

  def like
    @post = Post.find_by id: params[:id]

    return if @post.nil?

    like = Like.where(likeable: @post, user: current_user).first

    like&.destroy
    Like.create(likeable: @post, user: current_user) unless like

    @is_liked = @post.liked_by? current_user

    respond_to { |format| format.turbo_stream }
  end

  def save
    @post = Post.find_by id: params[:id]

    return if @post.nil?

    if current_user.saved_posts.find_by id: @post.id
      current_user.saved_posts.delete @post
    else
      current_user.saved_posts << @post
    end

    respond_to do |format|
      if request.referer&.include? user_path(current_user) # we came from user detail page
        format.turbo_stream { render turbo_stream: turbo_stream.remove("saved-post-#{@post.id}") }
      else
        format.turbo_stream
      end
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :image)
  end
end
