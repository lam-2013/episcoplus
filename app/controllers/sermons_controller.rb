class SermonsController < ApplicationController

  # check if the user is logged in
  before_filter :signed_in_user
  # check if the user is allowed to delete a post
  before_filter :correct_user, only: :destroy

  def create
    # build a new post from the information contained in the "new post" form
    @sermon = current_user.sermons.build(params[:sermon])
    if @sermon.save
      flash[:success] = 'Sermon created!'
      redirect_to current_user
    else
      @feed_items = []
      render 'pages/home'
    end
  end

  def destroy
    @sermon.destroy
    redirect_to current_user
  end

  def show

  end

  def new
    # init the user variable to be used in the sign up form
    @sermon = Sermon.new
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @sermon = current_user.sermons.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @sermon.nil?
  end

end
