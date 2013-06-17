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

  # Paginated search
  def search
    @users = User.search(params[:search]).paginate(page: params[:user_page], per_page: 5)
    @sermons = Sermon.search(params[:search]).paginate(page: params[:sermon_page], per_page: 5)

    if (params[:change]=1)
      respond_to do |format|
        format.html # index.html.erb
        ajax_respond format, :section_id => 'user_search', :render => {:file => 'users/_search_page'}
      end
    elsif (params[:change]=2)
      respond_to do |format|
        format.html # index.html.erb
        ajax_respond format, :section_id => 'sermon_search', :render => {:file => 'sermons/_search_page'}
      end
    end

  end

end
