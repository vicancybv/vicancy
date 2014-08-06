ActiveAdmin.register Video do

  action_item only: [:show, :edit] do |video|
    link_to('New Uploaded Video for this Video', new_admin_uploaded_video_url('uploaded_video[video_id]' => params[:id]))
  end

  form do |f|
    f.inputs 'Video' do
      f.input :aasm_state,
              as: :select,      
              collection: ["processing", "uploaded", "error"]
    end
    f.inputs I18n.t('admin.User') do
      f.input :user
    end
    f.inputs I18n.t('admin.Client') do
      f.input :client
    end
    f.inputs I18n.t('admin.Caption') do
      f.input :language,  
              as: :select,      
              collection: { 
                "English" => "en", 
                "Dutch" => "nl"
              }
      f.input :title, hint: I18n.t(:'admin.optional')
      f.input :summary, hint: I18n.t(:'admin.optional')
    end
    f.inputs I18n.t(:'admin.Job') do
      f.input :job_title
      f.input :company
      f.input :job_ad_url
    end
    f.actions



  end

  show do |video|

    attributes_table do
      row 'Client' do |video|
        link_to video.client.name, admin_client_url(video.client)
      end
      row '(User)' do |video|
        link_to "(#{video.user.name})", admin_user_url(video.user)
      end
      row :job_title
      row :company
      row :aasm_state
    end


    panel "Video edits" do
      table_for video.video_edits do
        column "ID" do |video_edit| 
          link_to video_edit.id, admin_video_edit_url(video_edit)
        end
        column :edits
      end

    end

    panel "Uploaded videos" do
      table_for video.uploaded_videos do
        column "ID" do |uploaded_video| 
          link_to uploaded_video.id, admin_uploaded_video_url(uploaded_video)
        end
        column :provider
        column "Provider ID", :provider_id
        column "Status", :aasm_state
      end
    end

  end

  index do
    selectable_column
    column :user
    column :job_title
    column :company
    column :aasm_state
    column :created_at
    actions    
  end

end
