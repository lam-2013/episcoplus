class PagesController < ApplicationController
  def home
    if signed_in?
      @post = current_user.posts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    else
      redirect_to welcome_url
    end

  end

  def welcome

  end

  def about
  end

  def contact
  end

  def faq
  end
end
