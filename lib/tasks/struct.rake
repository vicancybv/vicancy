RESELLERS = [
    5,8,9,10,13,14,16,18,19,20,24,25,26,27,28,30,31,44
]
CLIENTS = [
    6,11,12,17,23,29,32,33,34,35,36,37,38,40,41,42,43,45,46,47,48,49,50,51,52,53,54,55,56,58,59,60
]
TESTACC = [
    2,3,4,15
]
namespace :struct do
  desc 'Output new structure'
  task out: :environment do
    User.order(:id).each do |user|
      #p user
      videos = user.videos.to_a
      videos.sort! { |a,b| a.company <=> b.company}
      if RESELLERS.include? user.id
        videos.each do |video|
          puts "#{user.id}, #{user.name}, #{user.language}, #{video.company}, #{video.language}, #{video.id}, #{video.company}, #{video.language}, #{video.job_title}"
        end
      elsif CLIENTS.include? user.id
        videos.each do |video|
          puts "-, Vicancy (reseller), en, #{user.name}, #{user.language}, #{video.id}, #{video.company}, #{video.language}, #{video.job_title}"
        end
      elsif TESTACC.include? user.id
        videos.each do |video|
          puts "+, Vicancy (test), en, #{user.name}, #{user.language}, #{video.id},  #{video.company}, #{video.language}, #{video.job_title}"
        end
      else
        raise "Uncategorized user id: #{user.id}"
      end

    end
  end
end
