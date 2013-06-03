class User < ActiveRecord::Base
  attr_accessible :aboutMe, :age, :birth, :confirmed, :diocese, :email, :honorific, :id, :institute, :interests, :name, :orderDay, :password, :password_confirmation, :placeForRole, :role, :study, :surname

  has_secure_password

  # put the email in downcase before saving the user
  before_save { |user| user.email = email.downcase }
  # call the create_remember_token private method before saving the user
  before_save :create_remember_token

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+.[a-z]+\z/i
  # M/D/YY or M/D/YYYY or MM/DD/YYYY
  VALID_DATE_REGEX = /^((0?[13578]|10|12)(-|\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[01]?))(-|\/)((19)([2-9])(\d{1})|(20)([01])(\d{1})|([8901])(\d{1}))|(0?[2469]|11)(-|\/)(([1-9])|(0[1-9])|([12])([0-9]?)|(3[0]?))(-|\/)((19)([2-9])(\d{1})|(20)([01])(\d{1})|([8901])(\d{1})))$/


  validates :name, presence: true, length: { maximum: 50 };
  validates :surname, presence: true, length: { maximum: 50 };
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX }, uniqueness: { case_sensitive: false }
  #validates :birth, format: { with: VALID_DATE_REGEX }
  #validates :orderDay, format: { with: VALID_DATE_REGEX }
  validates :password, presence: true, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  # private methods
  private

  def create_remember_token
    # create a random string, save for use in URIs and cookies, for the user remember token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end
