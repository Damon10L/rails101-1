class Account::PostsController < ApplicationController
  before_action :authenticate_user!
  def index
    @posts = current_user.posts
  end
  def new
    @group = Group.find(params[:group_id])
    @post = Post.new
  end

  def create
    @group = Group.find(params[:group_id])
    @post = Post.new(post_params)
    @post.group = @group
    @post.user = current_user
    if @post.save
      redirect_to group_path(@group)
    else
      render :new
    end

  end


private

  def post_params
    params.require(:post).permit(:content)
  end

  def check_if_memeber_of_group
    @group = Group.find(params[:group_id])
    if !current_user.is_member_of?(@group)
      redirect_to group_path(@group), alert:"you have no permission"
    end
  end

end
