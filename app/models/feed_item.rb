class FeedItem < ActiveRecord::Base
  attr_accessible :user_id

  belongs_to :doc, :polymorphic => true

  default_scope order: 'feed_items.updated_at DESC'

  # get user's contents plus all the contents written by her followed users
  # for contents liked from friends, get only like news
  def self.from_users_followed_by(user)
    followed_user_ids = 'SELECT followed_id FROM relationships WHERE follower_id = :user_id'

    liked_post_id = "SELECT DISTINCT doc_id FROM likes WHERE (user_id IN (#{followed_user_ids}) OR user_id = :user_id) AND doc_type = 'Post' GROUP BY doc_type, doc_id"
    liked_sermon_id = "SELECT DISTINCT doc_id FROM likes WHERE (user_id IN (#{followed_user_ids}) OR user_id = :user_id) AND doc_type = 'Sermon' GROUP BY doc_type, doc_id"
    latest_like_per_elements = "SELECT MAX(id) FROM likes WHERE user_id IN (#{followed_user_ids}) OR user_id = :user_id GROUP BY doc_type, doc_id"

    where("(user_id IN (#{followed_user_ids}) OR user_id = :user_id) AND
            (
              (doc_type = 'Post' AND doc_id NOT IN (#{liked_post_id})) OR
              (doc_type = 'Sermon' AND doc_id NOT IN (#{liked_sermon_id})) OR
              doc_id in (#{latest_like_per_elements})
            )", user_id: user.id)
  end

end
