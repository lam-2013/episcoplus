class FeedItemsController < ApplicationController
  # check if the user is logged in
  before_filter :signed_in_user

end
