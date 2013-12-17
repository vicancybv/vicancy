class CreateVideoRequests < ActiveRecord::Migration
  def change
    create_table :video_requests do |t|
      t.references :user
      t.string :user_ip
      t.string :link
      t.text :comment

      t.timestamps
    end
  end
end
