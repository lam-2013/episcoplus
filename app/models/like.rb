class Like < ActiveRecord::Base
  attr_accessible :doc_id, :doc_type, :user_id

  belongs_to :doc, :polymorphic => true
  has_one :feed_item, :as => :doc, :dependent => :destroy

  def relatedUser
    User.find(user_id)
  end

  validates :user_id, presence: true
  validates :doc_id, presence: true
  validates :doc_type, presence: true

end
