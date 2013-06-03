class SessionsController < ApplicationController

  def new
    # intentionally left empty: no need to pass any data to the sign in form
  end

  def create
    # get the user email from the sign in form
    user = User.find_by_email(params[:session][:email].downcase)
    # check if the retrieved user is valid
    if user && user.authenticate(params[:session][:password])
      # handle successful login
      sign_in user # sign in method implemented in the SessionsHelper class
      redirect_to user # redirect to user profile page (same of redirect_to user_path(user))
    else
      # handle wrong login information, by using flash.now that is specifically design for showing the flash on rendered page
      flash.now[:error] = 'Invalid email/password combination'
      # go back to the sign in page
      render 'new'
    end
  end

  def destroy
    # sign out the current user
    sign_out
    # go to the home
    redirect_to root_path
  end

end
