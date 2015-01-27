namespace :thumbs do
  desc 'Get thumbnails for uploaded videos'
  task get: :environment do
    UploadedVideo.where(provider: 'vimeo', thumb_small: nil).each do |uploaded_video|
      puts "#{uploaded_video.provider}: #{uploaded_video.provider_id}"
      uploaded_video.get_thumbnails
      puts 'Done.'
    end
    UploadedVideo.where(provider: 'youtube', thumb_small: nil).each do |uploaded_video|
      puts "#{uploaded_video.provider}: #{uploaded_video.provider_id}"
      uploaded_video.get_thumbnails
      puts 'Done.'
    end
  end

  desc 'Repair thumbnails for uploaded videos & generate videos'
  task repair: :environment do
    Video.all.each do |video|
      [video.youtube, video.vimeo, video.wistia].each do |uploaded_video|
        if uploaded_video.present? && uploaded_video.thumbnail.blank?
          puts "#{uploaded_video.provider}: #{uploaded_video.provider_id}"
          begin
            uploaded_video.build_thumbnail
            puts 'Done.'
          rescue => e
            puts "Failed: #{e.message} (#{e.class.to_s})"
          end
        end
      end
    end
  end

end
