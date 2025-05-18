class User < ApplicationRecord
  acts_as_paranoid
  
  has_secure_password
  
  has_many :entities
  has_many :events
  has_many :participants
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?, on: :create
  
  private
  
  def password_required?
    password_digest.nil? || password.present?
  end
end
