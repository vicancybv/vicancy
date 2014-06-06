class PopulateUploadedVideos < ActiveRecord::Migration
  def up
    Video.all.each do |v|
      [:vimeo, :youtube].each do |provider|
        if provider_id = v.attributes["#{provider.to_s}_id"]
          v.uploaded_videos.create(provider: provider.to_s, provider_id: provider_id, aasm_state: "uploaded")
        end
      end
    end

  end

  def down
    UploadedVideo.destroy_all
  end
end
