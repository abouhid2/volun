class PictureSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes :id, :image_url, :created_at, :updated_at, :image_attachment_url
  
  def image_attachment_url
    return nil unless object.image.attached?
    
    rails_blob_url(object.image)
  end
end 