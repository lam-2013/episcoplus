class UsersController < ApplicationController
  # check if the user is logged in (e.g., for editing only his information)
  before_filter :signed_in_user, only: [:edit, :update, :index, :destroy]
  # check if the current user is the correct user (e.g., for editing only his information)
  before_filter :correct_user, only: [:edit, :update]
  # check if the current user is also an admin
  before_filter :admin_user, only: :destroy

  def show
    # get the user with id :id
    @user = User.find(params[:id])

    # get and paginate the posts associated to the specified user
    @posts = @user.posts.paginate(page: params[:post_page])

    @post = current_user.posts.build if signed_in? && current_user?(@user)

    #rimosso .unscoped perchè metteva le omelie di altri - TODO cercare di farle apparire in ordine cronologico
    @last_sermons = @user.sermons.reorder("#{Sermon.table_name}.created_at DESC").limit(3)

    @display_followers = @user.followers.paginate :page => params[:followers_page], :per_page => 5, :order => 'TRIM(LOWER(name))'
    @display_followed = @user.followed_users.paginate :page => params[:followed_page], :per_page => 5, :order => 'TRIM(LOWER(name))'

    if (params[:change]=1)
      respond_to do |format|
        format.html # index.html.erb
        ajax_respond format, :section_id => 'followers_popup', :render => {:file => 'users/_followers_popup'}
      end
    elsif (params[:change]=2)
      respond_to do |format|
        format.html # index.html.erb
        ajax_respond format, :section_id => 'followed_popup', :render => {:file => 'users/_followed_popup'}
      end
    end
  end

  def new
    # init the user variable to be used in the sign up form
    @user = User.new
  end

  def create
    # refine the user variable content with the data passed by the sign up form
    @user = User.new(params[:user])
    if @user.admin.nil?
      @user.admin = false
    end
    if @user.save
      # handle a successful save
      flash[:success] = 'Benvenuto in episco+!'
      # automatically sign in
      sign_in @user
      redirect_to @user
    else
      render 'new'
    end
  end

  def edit
    # intentionally left empty since the correct_user method (called by before_filter) initialize the @user object
    # without the correct_user method, this action should contain:
    # @user = User.find(params[:id])
  end

  def update
    # intentionally left empty since the correct_user method (called by before_filter) initialize the @user object
    # without the correct_user method, this action should also contain:
    # @user = User.find(params[:id])
    # check if the update was successfully
    if @user.update_attributes(params[:user])
      # handle a successful update
      flash[:success] = 'Profile updated'
      # re-login the user
      sign_in @user
      # go to the user profile
      redirect_to @user
    else
      # handle a failed update
      render 'edit'
    end
  end

  def index
    # get all the users from the database - without pagination
    # @users = User.all

    # get all the users from the database - with pagination
    @users = User.paginate(page: params[:page])

  end

  def destroy
    # delete the user starting from her id
    User.find(params[:id]).destroy
    flash[:success] = 'User deleted!'
    redirect_to users_url
  end


  def sermons
    @user = User.find(params[:id])
    @title = "Omelie di #{@user.full_name}"

    #rimosso .unscoped perchè metteva le omelie di altri - TODO cercare di farle apparire in ordine cronologico
    @sermons = @user.sermons.reorder("#{Sermon.table_name}.created_at DESC").paginate(page: params[:page], per_page: 10)

    @available_type = Sermon.where("type_of_liturgy IS NOT NULL").select(:type_of_liturgy).uniq

    render 'sermons/index'
  end

  private

  # Take the current user information (id) and redirect her to the home page if she is not the 'right' user
  def correct_user
    # init the user object to be used in the edit and update actions
    @user = User.find(params[:id])
    redirect_to root_path unless current_user?(@user) # the current_user?(user) method is defined in the SessionsHelper
  end

  # Redirect the user to the home page is she is not an admin (e.g., if the user cannot perform an admin-only operation)
  def admin_user
    redirect_to root_path unless current_user.admin?
  end

end
