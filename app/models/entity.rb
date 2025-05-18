class Entity < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user
  has_many :events, dependent: :destroy
  
  validates :name, presence: true
end
