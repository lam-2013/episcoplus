class SermonsController < ApplicationController

  # check if the user is logged in
  before_filter :signed_in_user
  # check if the user is allowed to delete a post
  before_filter :correct_user, only: :destroy

  def create
    # build a new sermon from the information contained in the new sermon form
    @sermon = current_user.sermons.build(params[:sermon])
    @sermon.build_feed_item(user_id: current_user.id)

    @sermon.subtitle = nil if @sermon.subtitle.strip.empty?

    if @sermon.multimedia_url.strip.empty?
      @sermon.multimedia = nil
      @sermon.multimedia_url = nil
    end

    @sermon.type_of_liturgy = nil if @sermon.type_of_liturgy.strip.empty?


    if @sermon.save
      flash[:success] = 'Omelia pubblicata!'
      redirect_to @sermon
    else
      render 'new'
    end
  end

  def destroy
    @sermon.destroy
    redirect_to current_user
  end

  def show
    @sermon = Sermon.find(params[:id])
    @user = @sermon.user
    @comment = Comment.new
    @comments = @sermon.comments
  end

  def new
    # init the sermon variable, belonging to current user
    @sermon = current_user.sermons.build if signed_in?
  end

  def index
    # get all the users from the database - with pagination
    if params[:tag]
      @sermons = Sermon.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 10)
    else
      @sermons = Sermon.orderByLike(current_user).paginate(page: params[:page], per_page: 10)
    end

    #collections for left boxes
    @available_type = Sermon.where("type_of_liturgy IS NOT NULL").select(:type_of_liturgy).uniq

  end

  def search
    where_condition = ''
    if params[:day] && !params[:day].empty?
      if !where_condition.empty?
        where_condition << ' AND '
      end
      where_condition << "date(day) = date('#{params[:day].to_date}')"
    else
      params[:day] = nil
    end
    if params[:type_of_liturgy] && !params[:type_of_liturgy].empty?
      if !where_condition.empty?
        where_condition << ' AND '
      end
      where_condition << "type_of_liturgy = '#{params[:type_of_liturgy]}'"
    else
      params[:type_of_liturgy] = nil

    end

    isArgumentPresent = params[:argument] && !params[:argument].strip.empty?
    if params[:argument] && !params[:argument].strip.empty?
      # remove blank space
      text = params[:argument].strip
      #tranform in regex, i.e. word1|word2
      text = text.gsub(' ', '|')

      if !where_condition.empty?
        where_condition << ' AND '
      end

      #SEARCH IN TITLE
      where_condition << "(title||(case when subtitle is null then '' else subtitle end) REGEXP '#{text}'"

      join_condition = "LEFT OUTER JOIN
                            (SELECT taggings.taggable_id AS taggable_id, tags.name AS tag_name
                              FROM taggings LEFT OUTER JOIN tags ON taggings.tag_id = tags.id
                              WHERE taggable_type='Sermon') AS tagsTable
                    ON tagsTable.taggable_id = sermons.id"
      #SEARCH IN TAG
      text.split('|').each do |word|
        where_condition << " OR tag_name = '#{word}'"
      end
      where_condition << ")"
    end

    if !where_condition.empty?
      if join_condition
        result_id = "SELECT #{Sermon.table_name}.id FROM #{Sermon.table_name} #{join_condition} WHERE #{where_condition}"
        @sermons = Sermon.where("id IN (#{result_id})").paginate(page: params[:page], per_page: 10)
      else
        @sermons = Sermon.where(where_condition).paginate(page: params[:page], per_page: 10)
      end
    else
      @sermons = Sermon.paginate(page: params[:page], per_page: 10)
    end

    @available_type = Sermon.where("type_of_liturgy IS NOT NULL").select(:type_of_liturgy).uniq

    render 'sermons/index'
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @sermon = current_user.sermons.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @sermon.nil?
  end

end
