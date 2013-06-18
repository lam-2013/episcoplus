class CommentsController < ApplicationController
  before_filter :signed_in_user

  respond_to :html, :js

  def create
    @comment = Comment.new(params[:comment])
    @comment.user_id = current_user.id

    # TODO create news
    #@comment.create_feed_item(user_id: current_user.id)

    if @comment.save
      flash[:success] = "Commento inserito!"
      @sermon = Comment.find(@comment.id).doc
      # without javascript: redirect_to home
      respond_with sermons_path
      # Rails will look for a create.js.erb file for responding to this action with ajax
    else
      flash[:error] = "Commento non inserito!"
      respond_with sermons_path
    end

  end

end
