class PostsController < ApplicationController
  # check if the user is logged in
  before_filter :signed_in_user
  # check if the user is allowed to delete a post
  before_filter :correct_user, only: :destroy

  def create
    # build a new post from the information contained in the "new post" form
    @post = current_user.posts.build(params[:post])
    if @post.save
      flash[:success] = 'Post created!'
      redirect_to root_url
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @post.destroy
    redirect_to current_user
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @post = current_user.posts.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @post.nil?
  end

end