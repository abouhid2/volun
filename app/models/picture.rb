class Picture < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :imageable, polymorphic: true
  has_one_attached :image
  
  validate :image_or_url_present
  
  after_create :process_attached_image
  
  private
  
  def image_or_url_present
    if !image.attached? && image_url.blank?
      errors.add(:base, "Either an image or an image URL must be provided")
    end
  end
  
  def process_attached_image
    return unless image.attached? && image_url.blank?
    
    update_column(:image_url, Rails.application.routes.url_helpers.rails_blob_path(image, only_path: true))
  end
end
