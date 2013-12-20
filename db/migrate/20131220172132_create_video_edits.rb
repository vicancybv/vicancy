class CreateVideoEdits < ActiveRecord::Migration
  def change
    create_table :video_edits do |t|
      t.text :edits
      t.references :video
      t.string :user_ip

      t.timestamps
    end
    add_index :video_edits, :video_id
  end
end
