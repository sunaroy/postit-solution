class CommentsController < ApplicationController
  before_action :require_user
  def create
    @post =Post.find(params[:post_id])
    @comment =@post.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      flash[:notice]="your comment is successfuly submitted"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    comment = Comment.find(params[:id])
    vote = Vote.create(voteable: comment, user: current_user, vote: params[:vote])
    if vote.valid?
    flash[:notice] = "Your vote was counted."
    else
      flash[:notice] = "You can only vote on a coment once"
    end
    redirect_to :back
  end

  def comment_params
    params.require(:comment).permit(:body)
  end
end