class CommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @original_comment_id = params[:comment_id]

    @comment = current_user.comments.build(body: params[:comment][:body],
                                           commentable_id: @original_comment_id || params[:post_id],
                                           commentable_type: @original_comment_id ? 'Comment' : 'Post'
                                          )
    
    respond_to do |format|
      if @comment.save
        if @original_comment_id.nil?
          format.turbo_stream { render turbo_stream: turbo_stream.append('post-comments', @comment) }
        else
          format.turbo_stream
        end
      else
        @post = @comment.root_post
        format.html { render 'posts/show', status: :unprocessable_entity }
      end
    end
  end

  def new_reply
    @original_comment = Comment.find_by id: params[:comment_id]
    @new_comment = Comment.new
  end

  def index_reply
    @comment = Comment.find_by id: params[:comment_id]
  end
end
