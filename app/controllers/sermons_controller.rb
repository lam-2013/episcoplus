class SermonsController < ApplicationController

  # check if the user is logged in
  before_filter :signed_in_user
  # check if the user is allowed to delete a post
  before_filter :correct_user, only: :destroy

  def create
    # build a new post from the information contained in the "new post" form
    @sermon = current_user.sermons.build(params[:sermon])
    @sermon.build_feed_item(user_id: current_user.id)

    @sermon.subtitle = nil if @sermon.subtitle.strip.empty?

    @sermon.type_of_liturgy = nil if @sermon.type_of_liturgy.strip.empty?


    if @sermon.save
      flash[:success] = 'Omelia pubblicata!'
      redirect_to @sermon
    else
      render 'new'
    end
  end

  def destroy
    @sermon.destroy
    redirect_to current_user
  end

  def show
    @sermon = Sermon.find(params[:id])
    @user = @sermon.user
  end

  def new
    # init the sermon variable, belonging to current user
    @sermon = current_user.sermons.build if signed_in?
  end

  def index
    # get all the users from the database - with pagination


    if params[:tag]
      @sermons = Sermon.tagged_with(params[:tag])
      Sermon.paginate(page: params[:tag])
    else
      @sermons = Sermon.paginate(page: params[:page])
    end
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @sermon = current_user.sermons.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @sermon.nil?
  end

end
