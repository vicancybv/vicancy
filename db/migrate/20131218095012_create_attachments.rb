class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :video_request

      t.timestamps
    end
    add_index :attachments, :video_request_id
  end
end
