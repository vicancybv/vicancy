class CreateVimeoImports < ActiveRecord::Migration
  def change
    create_table :vimeo_imports do |t|
      t.string :vimeo_id
      t.string :wistia_id

      t.timestamps
    end
  end
end
