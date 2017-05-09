class PostsController < ApplicationController
  before_action :authenticate_user!, :only => [:new, :create]
  before_action :check_if_memeber_of_group, :only=> [:new, :create]
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

    def destroy
      @group = Group.find(params[:group_id])
      @post = Post.find(params[:id])
      @post.group = @group
      @post.destroy
      redirect_to account_posts_path, alert: "Post deleted"
    end

    def edit
       @group = Group.find(params[:group_id])
       @post = Post.find(params[:id])
       @post.group = @group
     end

    def update
       @group = Group.find(params[:group_id])
       @post = Post.find(params[:id])
       @post.group = @group
       @post.user = current_user

       if @post.update(post_params)
         redirect_to account_posts_path, notice: "Update Success"
       else
         render :edit
       end
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
