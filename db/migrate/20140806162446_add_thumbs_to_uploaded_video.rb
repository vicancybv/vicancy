class AddThumbsToUploadedVideo < ActiveRecord::Migration
  def change
    add_column :uploaded_videos, :thumb_small, :string
    add_column :uploaded_videos, :thumb_medium, :string
    add_column :uploaded_videos, :thumb_large, :string
  end
end
