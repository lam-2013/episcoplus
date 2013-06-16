class LikesController < ApplicationController
  # check if the user is logged in
  before_filter :signed_in_user

  # respond to the actions with html or javascript (see respond_with method)
  respond_to :html, :js

  def create
    # recupero la classe
    targetClass = Object.const_get(params[:like][:doc_type])
    @target = targetClass.find(params[:like][:doc_id])

    @like = @target.like!(current_user)
    #create news
    @like.create_feed_item(user_id: current_user.id)

    # without javascript: redirect_to home
    respond_with root_path
    # Rails will look for a create.js.erb file for responding to this action with ajax
  end

  def destroy
    @target = Like.find(params[:id]).doc
    # N.B. non ho bisogno di recuperare la classe
    @target.unlike!(current_user)
    # without javascript: redirect_to @user
    respond_with root_path
    # Rails will look for a destroy.js.erb file for responding to this action with ajax
  end
end
