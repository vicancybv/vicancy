class AddClientToVideoRequest < ActiveRecord::Migration
  def change
    add_column :video_requests, :client_id, :integer, references: :clients
    add_index :video_requests, :client_id
  end
end
