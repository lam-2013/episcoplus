# == Schema Information
#
# Table name: relationships
#
#  id          :integer          not null, primary key
#  follower_id :integer
#  followed_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Relationship < ActiveRecord::Base
  attr_accessible :followed_id

  # a relationship belongs to a follower (that is represented by the User model)
  belongs_to :follower, class_name: 'User'

  # a relationship belongs to a followed user (that is represented by the User model)
  belongs_to :followed, class_name: 'User'

  # both model attributes must be always present...
  validates :follower_id, presence: true
  validates :followed_id, presence: true

end
