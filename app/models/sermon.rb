class Sermon < ActiveRecord::Base
  attr_accessible :content, :day, :subtitle, :title, :type_of_liturgy, :tag_list, :audio, :video
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

  # get the searched user(s) by (part of her) title
  # TODO implements search by keyword
  def self.search(text)
    if text
      # remove blank space
      text = text.strip
      #tranform in regex, i.e. word1|word2
      text = text.gsub(' ', '|')

      where('title || (case when subtitle is null then "" else subtitle end) REGEXP ?', "#{text}")
    else
      scoped # return an empty result set
    end
  end

  # is the current liked by the given user?
  def isLikedBy?(user)
    likes.find_by_user_id(user.id)
  end

  # like from given user
  def like!(other_user)
    @like = likes.create!(user_id: other_user.id)
  end

  # like from given user
  def unlike!(other_user)
    likes.find_by_user_id(other_user.id).destroy
  end

end
