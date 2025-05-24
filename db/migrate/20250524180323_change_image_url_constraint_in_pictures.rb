class ChangeImageUrlConstraintInPictures < ActiveRecord::Migration[8.0]
  def change
    change_column_null :pictures, :image_url, true
  end
end
