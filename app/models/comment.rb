class Comment < ApplicationRecord
  belongs_to :event
  belongs_to :user, optional: true

  validates :content, presence: true
  validates :content, length: { minimum: 1, maximum: 1000 }
end 