class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.posts_for current_user
  end

  def show
    @post = Post.find_by id: params[:id]

    return redirect_to_root_with_flash('Post not found.') if @post.nil?

    @comments = @post.comments.includes(:user, :likes, :comments)
    @comment = Comment.new
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build post_params

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  def like
    @post = Post.find_by id: params[:id]

    return if @post.nil?
    
    like = Like.where(likeable: @post, user: current_user).first

    if like
      like.destroy
    else
      Like.create likeable: @post, user: current_user
    end

    @is_liked = @post.liked_by? current_user

    respond_to do |format|
      format.turbo_stream
    end
  end

  private

  def post_params
    params.require(:post).permit(:body, :image)
  end
end
