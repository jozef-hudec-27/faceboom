class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by id: params[:id]

    if @post.nil?
      flash[:alert] = 'Post not found.'
      redirect_to root_path
    end

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
    post = Post.find_by id: params[:id]
    like = Like.where(likeable: post, user: current_user).first

    if like
      like.destroy
    else
      Like.create likeable: post, user: current_user
    end

    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("post-#{post.id}-like-link", "#{post.likes.count} likes") }
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
