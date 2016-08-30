class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:show,:index]
  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment =Comment.new
  end

  def new
  @post = Post.new
  end

  def create
    create_params = post_params
    @post=Post.new(create_params[:post])
    @post.user= current_user
    if @post.save
      if create_params[:category_ids].present?
        create_params[:category_ids].each do |category_id|
          @post.post_categories.create!(category_id: category_id) if category_id.present?
        end
        end
      flash[:notice]="your post was created"
      redirect_to posts_path
    else
      render 'new'
    end
  end
  def edit

  end

  def update
    new_post_params ={}
    new_post_params[:post] = params.require(:post).permit(:title, :url, :description)
    new_post_params[:category_ids] =params[:post][:category_ids] if params[:post][:category_ids].present?
    if @post.update(new_post_params[:post])
      flash[:notice] = "your post was created"
      if new_post_params[:category_ids].present?
        new_post_params[:category_ids].each do |category_id|
          @post.post_categories.create!(category_id: category_id) if category_id.present?
        end
      end
      redirect_to posts_path
    end

  end
  def vote
    vote = Vote.create(voteable: @post, user: current_user, vote: params[:vote])

    if vote.valid?
      flash[:notice] = 'Your vote was counted.'
    else
      flash[:error] = 'You can only vote on a post once'
    end
    redirect_to :back
  end

private

  def post_params
    new_post_params = {}
    new_post_params[:post] = params.require(:post).permit( :title, :url, :description)
    new_post_params[:category_ids] = params[:post][:category_ids] if params[:post][:category_ids].present?
    new_post_params
  end

def set_post
  @post = Post.find(params[:id])
end

end