class User < ActiveRecord::Base
  attr_accessible :aboutMe, :age, :birth, :confirmed, :diocese, :email, :honorific, :id, :institute, :interests, :name, :orderDay, :password, :password_confirmation, :placeForRole, :role, :study, :surname, :admin

  has_secure_password

  # each user can have some posts associated and they must be destroyed together with the user
  has_many :posts, dependent: :destroy

  # each user can have some sermons associated and they must be destroyed together with the user
  has_many :sermons, dependent: :destroy

  # each user can have many relationships
  # we need to explicitly define a foreign key since, otherwise, Rails looks for a relationship_id column (that not exists)
  has_many :relationships, foreign_key: 'follower_id', dependent: :destroy

  # each user can have many followed users, through the relationships table
  # since followed_users does not exist, we need to give to Rails the right column name in the relationships column (with source: "followed_id")
  has_many :followed_users, through: :relationships, source: :followed

  # each user can have many "reverse" relationships (by inverse reading the Relationship model)
  has_many :reverse_relationships, foreign_key: 'followed_id', class_name: 'Relationship', dependent: :destroy

  # each user can have many followers, through reverse relationships
  has_many :followers, through: :reverse_relationships
  # put the email in downcase before saving the user
  before_save { |user| user.email = email.downcase }
  # call the create_remember_token private method before saving the user
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+.[a-z]+\z/i
  # M/D/YY or M/D/YYYY or MM/DD/YYYY
  VALID_DATE_REGEX = /^((0?[13578]|10|12)(-|\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[01]?))(-|\/)((19)([2-9])(\d{1})|(20)([01])(\d{1})|([8901])(\d{1}))|(0?[2469]|11)(-|\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[0]?))(-|\/)((19)([2-9])(\d{1})|(20)([01])(\d{1})|([8901])(\d{1})))$/


  validates :name, presence: true, length: {maximum: 50};
  validates :surname, presence: true, length: {maximum: 50};
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}
  #validates :birth, format: { with: VALID_DATE_REGEX }
  #validates :orderDay, format: { with: VALID_DATE_REGEX }
  validates :password, presence: true, length: {minimum: 6}
  validates :password_confirmation, presence: true


  # is the current user following the given user?
  def following?(other_user)
    relationships.find_by_followed_id(other_user.id)
  end

  # follow a give user
  def follow!(other_user)
    relationships.create!(followed_id: other_user.id)
  end

  # unfollow a given user
  def unfollow!(other_user)
    relationships.find_by_followed_id(other_user.id).destroy
  end

  # get the post to show in the wall
  def feed
    Post.from_users_followed_by(self)
  end

  # get the searched user(s) by (part of her) name
  def self.search(user_name)
    if user_name
      where('name LIKE ?', "%#{user_name}%")
    else
      scoped # return an empty result set
    end
  end

  # private methods
  private

  def create_remember_token
    # create a random string, save for use in URIs and cookies, for the user remember token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
