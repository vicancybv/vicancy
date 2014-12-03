require 'uri'
require 'bitly'

class ConvertJobAdUrlToJobUrl < ActiveRecord::Migration
  class Video < ActiveRecord::Base
    attr_accessible :job_ad_url, :job_url, :short_job_url
  end

  def update_url(url, video)
    puts "#{url}"
    return if url.blank?
    url.strip!
    url = 'http://'+url if url.start_with? 'bit.ly/'
    uri = URI(url)
    if uri.host == 'bit.ly'
      video.short_job_url = url
      video.job_url = Bitly.client.expand(url).long_url
      puts " -> #{video.job_url}"
    else
      puts " -> #{url}"
      video.job_url = url
    end
  end

  def change
    Video.all.each do |video|
      update_url(video.job_ad_url, video)
      video.save!
    end
  end
end
