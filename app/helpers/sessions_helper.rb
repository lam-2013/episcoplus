module SessionsHelper

  # Sign in method: store the remember token in a permanent cookie (it lasts for 20 years...)
  # and set the user performing the sign in as the current user
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    # self is mandatory to tell Rails that current_user is a method already defined and not a variable to be created
    self.current_user = user # equivalent to: self.current_user=(user)
  end

  # Set current user method: set the user performing the sign in as the current user
  def current_user=(user)
    @current_user = user
  end

  # Get current user method: get the user corresponding to the remember token only if @current_user is undefined
  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end

  # Is the current user signed in?
  def signed_in?
    !current_user.nil?
  end

  # Sign out method: clear the current user instance variable and delete the corresponding cookie
  def sign_out
    self.current_user = nil
    cookies.delete(:remember_token)
  end

end
