class FeedItem < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :doc, :polymorphic => true

  default_scope order: 'feed_items.updated_at DESC'

  # get user's contents plus all the contents written by her followed users
  def self.from_users_followed_by(user)
    followed_user_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id", user_id: user.id)
  end

end
