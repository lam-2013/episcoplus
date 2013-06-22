class SermonsController < ApplicationController

  # check if the user is logged in
  before_filter :signed_in_user
  # check if the user is allowed to delete a post
  before_filter :correct_user, only: :destroy

  def create
    # build a new post from the information contained in the "new post" form
    @sermon = current_user.sermons.build(params[:sermon])
    @sermon.build_feed_item(user_id: current_user.id)

    @sermon.subtitle = nil if @sermon.subtitle.strip.empty?


=begin
    @sermon.video = nil if @sermon.video.strip.empty?
=end

    @sermon.audio = nil if @sermon.audio.strip.empty?

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
      @sermons = Sermon.tagged_with(params[:tag]).paginate(page: params[:page])
    else
      @sermons = Sermon.paginate(page: params[:page])
    end

    @available_type = Sermon.where("type_of_liturgy IS NOT NULL").select(:type_of_liturgy).uniq
  end

  def search
    where_condition = ''
    if params[:day] && !params[:day].empty?
      if !where_condition.empty?
        where_condition << ' AND '
      end
      where_condition << "date(day) = date('#{params[:day].to_date}')"
    end
    if params[:type_of_liturgy] && !params[:type_of_liturgy].empty?
      if !where_condition.empty?
        where_condition << ' AND '
      end
      where_condition << "type_of_liturgy = '#{params[:type_of_liturgy]}'"
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
        @sermons = Sermon.joins(join_condition).where(where_condition).paginate(page: params[:page])
      else
        @sermons = Sermon.where(where_condition).paginate(page: params[:page])
      end
    else
      redirect_to sermons_path
    end

    @available_type = Sermon.where("type_of_liturgy IS NOT NULL").select(:type_of_liturgy).uniq
  end

  private

  def correct_user
    # does the user have a post with the given id?
    @sermon = current_user.sermons.find_by_id(params[:id])
    # if not, redirect to the home page
    redirect_to root_url if @sermon.nil?
  end

end
