class Sermon < ActiveRecord::Base
  attr_accessible :content, :day, :subtitle, :title, :type_of_liturgy, :tag_list, :multimedia, :multimedia_url
  acts_as_taggable

  # each sermon belong to a specific user
  belongs_to :user
  has_one :feed_item, as: :doc
  has_many :likes, as: :doc
  has_many :comments, as: :doc

  # user_id must be present while creating a new sermon...
  validates :user_id, presence: true

  # title must be present
  validates :title, presence: true

  # content must be present
  validates :content, presence: true

  def self.default_scope
    last_week = "created_at >= '#{(Time.now - 8.days).utc.iso8601}'"
    num_likes = "SELECT doc_id, count(id) AS nlikes FROM #{Like.table_name} WHERE doc_type = 'Sermon' and #{last_week} GROUP BY doc_id"
    #order by mumber of likes
    joins("LEFT OUTER JOIN (#{num_likes}) AS num_likes ON num_likes.doc_id=#{Sermon.table_name}.id")
    .order("num_likes.nlikes DESC, #{Sermon.table_name}.created_at DESC")
  end

  # get the searched user(s) by (part of her) title
  def self.search(text)
    if text
      # remove blank space
      text = text.strip
      #tranform in regex, i.e. word1|word2
      text = text.gsub(' ', '|')

      where_condition = '(title || (case when subtitle is null then "" else subtitle end) REGEXP ?)'

      join_condition = "LEFT OUTER JOIN
                            (SELECT DISTINCT taggings.taggable_id AS taggable_id, tags.name AS tag_name
                              FROM taggings LEFT OUTER JOIN tags ON taggings.tag_id = tags.id
                              WHERE taggable_type='Sermon') AS tagsTable
                    ON tagsTable.taggable_id = sermons.id"


      #SEARCH IN TAG
      text.split('|').each do |word|
        where_condition << " OR tag_name = '#{word}'"
      end

      result_id = "SELECT DISTINCT #{Sermon.table_name}.id FROM  #{Sermon.table_name} #{join_condition} WHERE #{where_condition}"

      where("id in (#{result_id})",  "#{text}")
    else
      scoped # return an empty result set
    end
  end

  # is the current liked by the given user?
  def isLikedBy?(user)
    likes.find_by_user_id(user.id)
  end

  # like from given user
  def like!(user)
    @like = likes.create!(user_id: user.id)
  end

  # like from given user
  def unlike!(user)
    likes.find_by_user_id(user.id).destroy
  end

  def self.orderByLike(user)
    #num di giorni da created_at
    delta = "(julianday('now')-julianday(created_at))"
    #per l'ordinamento, non mi interessano i dati più vecchi di un mese
    last_month = "created_at >= '#{(Time.now - 30.days).utc.iso8601}'"

    #current_user's followed
    followed_user_ids = "SELECT followed_id FROM relationships WHERE follower_id = #{user.id}"

    #raggruppa i like per sermon e genera una tabella con id e num_likes pesati rispetto ai giorni trascorsi
    #gli '1+' evitano le divisioni per zero e da zero
    number_of_like_table = "SELECT doc_id, ((1 + count(*))/( 1 + #{delta})) as number_of_likes FROM likes
                                    WHERE doc_type = 'Sermon' and #{last_month} GROUP BY doc_id"
    #i like dei friends valgono triplo (moltiplico per 2 e poi sommo)
    number_of_like_friends = "SELECT doc_id, (2*(1 + count(*))/( 1 + #{delta})) as number_of_likes FROM likes
                                    WHERE doc_type = 'Sermon' and user_id IN (#{followed_user_ids}) and #{last_month}
                                    GROUP BY doc_id"

    #bonus = una percentuale sulla media dei voti giornalieri nell'ultima settimata
    num_likes_last_week = "SELECT COUNT(*) AS number_of_likes FROM likes WHERE doc_type = 'Sermon' AND created_at >= '#{(Time.now - 8.days).utc.iso8601}' GROUP BY doc_id"
    bonus = "SELECT (AVG(number_of_likes)/7) AS bonus FROM (#{num_likes_last_week})"

    #rank = num di likes pesato + bonus
    rank = "((case when like_table.number_of_likes is null then 0 else like_table.number_of_likes end) +
            (case when friends_table.number_of_likes is null then 0 else friends_table.number_of_likes end) + ((#{bonus})/#{delta}))"

    #query
    unscoped.joins("LEFT OUTER JOIN (#{number_of_like_table})  AS like_table ON like_table.doc_id = #{Sermon.table_name}.id
                    LEFT OUTER JOIN (#{number_of_like_friends}) AS friends_table ON friends_table.doc_id = #{Sermon.table_name}.id")
    .select("#{Sermon.table_name}.*, #{rank} AS rank")
    .order("rank DESC, created_at DESC")
  end

end
