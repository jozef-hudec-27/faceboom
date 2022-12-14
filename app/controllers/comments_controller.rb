class CommentsController < ApplicationController
  before_action :authenticate_user!

  def index
    @post = Post.find_by id: params[:post_id]
    @comments = @post.comments
    @comment =  Comment.new
  end

  def create
    @parent_comment_id = params[:comment_id]

    @comment = current_user.comments.build(body: params[:comment][:body],
                                           commentable_id: @parent_comment_id || params[:post_id],
                                           commentable_type: @parent_comment_id ? 'Comment' : 'Post')

    respond_to do |format|
      if @comment.save
        format.turbo_stream
      else
        invalid_comment_msg_style = 'font-size: 0.6em; opacity: 0.7; margin-left: 8px;'
        format.turbo_stream do
          render(turbo_stream: turbo_stream.update(@parent_comment_id ? "#{@parent_comment_id}-invalid-reply-msg-wrapper" : 'invalid-post-comment-msg-wrapper',
                                                   "<p style='#{invalid_comment_msg_style}'>Invalid comment!</p>"))
        end
      end
    end
  end

  def destroy
    comment = current_user.comments.find_by id: params[:id]

    return redirect_to_root_with_flash("You don't have permission to do this.") if comment.nil?

    comment.destroy

    respond_to { |format| format.turbo_stream { render turbo_stream: turbo_stream.remove("comment-#{comment.id}") } }
  end

  def new_reply
    @parent_comment = Comment.find_by id: params[:comment_id]

    return redirect_to_root_with_flash('Comment not found.') if @parent_comment.nil?

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

    like&.destroy
    Like.create(likeable: @comment, user: current_user) unless like

    respond_to { |format| format.turbo_stream }
  end
end
