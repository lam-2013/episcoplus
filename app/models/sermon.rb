class Sermon < ActiveRecord::Base
  attr_accessible :content, :day, :subtitle, :title, :type_of_liturgy, :audio, :video

  # each sermon belong to a specific user
  belongs_to :user
  has_one :feed_item, as: :doc

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


end
