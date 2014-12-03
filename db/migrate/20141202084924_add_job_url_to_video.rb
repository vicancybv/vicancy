class AddJobUrlToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :job_url, :text
    add_column :videos, :short_job_url, :text
  end
end
