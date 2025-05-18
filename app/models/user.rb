class User < ApplicationRecord
  has_many :events
  has_many :participants
  
  has_secure_password
  
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
  
  private
  
  def password_required?
    password_digest.nil? || password.present?
  end
end
