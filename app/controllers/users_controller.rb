class UsersController < ApplicationController

  def show
    # get the user with id :id
    @user = User.find(params[:id])
  end

  def new
    # init the user variable to be used in the sign up form
    @user = User.new
  end

  def create
    # refine the user variable content with the data passed by the sign up form
    @user = User.new(params[:user])
    if @user.save
      # handle a successful save
      flash[:success] = 'Welcome to episco+!'
      redirect_to @user
    else
      render 'new'
    end
  end

end
