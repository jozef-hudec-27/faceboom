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
        invalid_comment_msg_style = 'font-size: 0.6em; opacity: 0.7; margin-left: 8px;'
        format.turbo_stream { render turbo_stream: turbo_stream.update(@original_comment_id ? "#{@original_comment_id}-invalid-reply-msg-wrapper" : 'new-post-comment-input',
                            "<p style='#{invalid_comment_msg_style}'>Invalid comment!</p>") }
      end
    end
  end

  def new_reply
    @original_comment = Comment.find_by id: params[:comment_id]

    return redirect_to_root_with_flash('Comment not found.') if @original_comment.nil?

    @new_comment = Comment.new
  end

  def index_reply
    @comment = Comment.find_by id: params[:comment_id]
    @replies = @comment.comments.includes :user, :likes, :comments
    return redirect_to_root_with_flash('Comment not found.') if @comment.nil?
  end

  def like
    @comment = Comment.find_by id: params[:id]

    return if @comment.nil?

    like = Like.where(likeable: @comment, user: current_user).first

    if like
      like.destroy
    else
      Like.create likeable: @comment, user: current_user
    end

    respond_to do |format|
      format.turbo_stream
    end
  end
end
