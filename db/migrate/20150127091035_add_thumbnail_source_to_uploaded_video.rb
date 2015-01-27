class AddThumbnailSourceToUploadedVideo < ActiveRecord::Migration
  def change
    add_column :uploaded_videos, :thumbnail_source, :string
  end
end
