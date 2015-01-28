class AddExternalJobIdToVideoRequest < ActiveRecord::Migration
  def change
    add_column :video_requests, :external_job_id, :string
  end
end
