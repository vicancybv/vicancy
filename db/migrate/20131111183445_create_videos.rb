class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :youtube_id
      t.string :vimeo_id
      t.string :job_ad_url
      t.string :job_title
      t.string :company
      t.string :language
      t.string :title
      t.text :summary

      t.timestamps
    end
  end
end
