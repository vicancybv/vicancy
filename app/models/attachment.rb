# == Schema Information
#
# Table name: attachments
#
#  id                :integer          not null, primary key
#  video_request_id  :integer          indexed
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#

class Attachment < ActiveRecord::Base
  belongs_to :video_request

  attr_accessible :file

  has_attached_file :file,
                    :storage => :s3,
                    :s3_permissions => :private,
                    :s3_credentials => {
                      :access_key_id => ENV['S3_ACCESS_KEY_ID'],
                      :secret_access_key => ENV['S3_SECRET_ACCESS_KEY']
                    },
                    :bucket => ENV['S3_BUCKET_NAME']
end
