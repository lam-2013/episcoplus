class Post < ActiveRecord::Base
  # To change this template use File | Settings | File Templates.
  attr_accessible :content
  attr_readonly :user_id

  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 400 }

  belongs_to(:user)

  # descending order for getting the posts
  default_scope order: 'posts.created_at DESC'

end



