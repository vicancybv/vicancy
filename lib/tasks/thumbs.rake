
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

end
