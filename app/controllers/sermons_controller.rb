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
      redirect_to @sermon
    else
      flash[:error] = 'Sermon not created!'
      render  'new'
    end
  end

  def destroy
    @sermon.destroy
    redirect_to current_user
  end

  def show
    @sermon = Sermon.find(params[:id])
    # get the user with id :id
    @user = User.find(params[:id])

    @sermon = current_user.sermons.build if signed_in? && current_user?(@user)
  end

  def new
    # init the sermon variable, belonging to current user
    @sermon = Sermon.new id:current_user.id
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @sermon = current_user.sermons.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @sermon.nil?
  end

end
