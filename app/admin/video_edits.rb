ActiveAdmin.register VideoEdit do

  form do |f|
    f.inputs I18n.t('admin.Video') do
      f.input :video
    end
    f.inputs I18n.t('admin.Video edit') do
      f.input :edits, label: "Edits"
      f.input :user_ip, label: "IP address"
    end

    

    f.actions
  end

  show do |video_edit|
    attributes_table do
      row :video_id
      row :edits
    end
  end

  index do
    selectable_column
    column :id
    column "Video" do |video_edit| 
      link_to video_edit.video.id, admin_video_url(video_edit.video)
    end
    column :edits
    column :created_at
    actions    
  end
  
end
