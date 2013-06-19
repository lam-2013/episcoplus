class Comment < ActiveRecord::Base
  attr_accessible :content, :doc_id, :doc_type, :user_id

  belongs_to :doc, :polymorphic => true

  default_scope order: 'comments.created_at DESC'

  def relatedUser
    User.find(user_id)
  end

  validates :user_id, presence: true
  validates :doc_id, presence: true
  validates :doc_type, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
