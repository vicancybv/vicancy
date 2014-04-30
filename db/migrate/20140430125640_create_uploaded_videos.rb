class CreateUploadedVideos < ActiveRecord::Migration
  def change
    create_table :uploaded_videos do |t|
      t.string :provider
      t.references :video
      t.string :aasm_state
      t.string :provider_id

      t.timestamps
    end
    add_index :uploaded_videos, :video_id
  end
end
