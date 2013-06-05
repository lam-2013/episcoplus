class Post < ActiveRecord::Base


# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  content    :string(255)
#  user_id    :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

  # only content must be accessible, in order to avoid manual (and wrong) associations between posts and users
  attr_accessible :content

  # each post belong to a specific user
  belongs_to :user

  # descending order for getting the posts
  default_scope order: 'posts.created_at DESC'

  # user_id must be present while creating a new post...
  validates :user_id, presence: true

  # content must be present and not longer than 400 chars
  validates :content, presence: true, length: {maximum: 400}
end
