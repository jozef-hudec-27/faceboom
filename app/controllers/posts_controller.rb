class PostsController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = Post.all
  end

  def show
    @post = Post.find_by(id: params[:id])

    if @post.nil?
      flash[:alert] = 'Post not found.'
      redirect_to root_path
    end
  end

  def new
    @post = Post.new
  end

  def create
    @post = current_user.posts.build(post_params)

    if @post.save
      redirect_to @post
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:body)
  end
end
