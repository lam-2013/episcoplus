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


end
