class AddFieldsToVideoRequest < ActiveRecord::Migration
  def change
    add_column :video_requests, :client_logo, :string
    add_column :video_requests, :job_title, :string
    add_column :video_requests, :job_body, :text
  end
end
