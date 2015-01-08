class AddExternalJobIdToVideo < ActiveRecord::Migration
  def change
    add_column :videos, :external_job_id, :string
  end
end
