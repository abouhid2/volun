class Entity < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :user
  has_many :events, dependent: :destroy
  has_many :inventories, dependent: :destroy
  has_many :requests, dependent: :destroy
  
  validates :name, presence: true
end
