class RelationshipsController < ApplicationController
  # user must be signed in to follow/unfollow someone
  before_filter :signed_in_user

  # respond to the actions with html or javascript (see respond_with method)
  respond_to :html, :js

  def create
    @user = User.find(params[:relationship][:followed_id])
    current_user.follow!(@user)
    # without javascript: redirect_to @user
    respond_with @user
    # Rails will look for a create.js.erb file for responding to this action with ajax
  end

  def destroy
    @user = Relationship.find(params[:id]).followed
    current_user.unfollow!(@user)
    # without javascript: redirect_to @user
    respond_with @user
    # Rails will look for a destroy.js.erb file for responding to this action with ajax
  end
end