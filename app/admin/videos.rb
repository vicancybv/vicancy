ActiveAdmin.register Video do

  action_item only: [:show, :edit] do |video|
    link_to('New Uploaded Video', new_admin_uploaded_video_url('uploaded_video[video_id]' => params[:id]))
  end
  action_item only: [:show, :edit] do |video|
    link_to('Rebuild All Thumbnails', rebuild_thumbnails_admin_video_url)
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
      f.input :external_job_id
      f.input :job_title
      f.input :company
      f.input :job_url
      f.input :short_job_url
      f.input :job_ad_url
    end
    f.actions
  end

  sidebar "Thumbnail", only: :show do
    if resource.thumbnail.blank?
      span 'No thumbnail. Rebuild it by clicking on button above.'
    else
      span do
        img src: resource.thumbnail_url({ size: '200x200', crop: :fit })
      end
      br
      span "Size: #{resource.thumbnail.width}x#{resource.thumbnail.height}"
      br
      span "Format: #{resource.thumbnail.format}"
      br
      link_to 'Thumbnail url', resource.thumbnail_url
    end
  end

  show do |video|

    attributes_table do
      row 'Client' do |video|
        video.client.present? ? link_to(video.client_name, admin_client_url(video.client)) : nil
      end
      row '(User)' do |video|
        video.user.present? ? link_to("(#{video.user_name})", admin_user_url(video.user)) : nil
      end
      row :external_job_id
      row :job_title
      row :job_ad_url
      row :job_url
      row :short_job_url
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
        column '' do |uploaded_video|
          img src: uploaded_video.thumbnail_url({size: '50x50', crop: :fit})
        end
        column :provider
        column "Provider ID", :provider_id
        column "Status", :aasm_state
      end
    end

  end

  index do
    selectable_column
    column :id
    column '' do |video|
      img src: video.thumbnail_url({size: '50x50', crop: :fit})
    end
    column :reseller
    column :client
    column :user
    column :job_title
    column :company
    column :external_job_id
    column :aasm_state
    column :created_at
    actions    
  end

  member_action :rebuild_thumbnails, method: :get do
    resource.rebuild_all_thumbnails
    redirect_to resource_path, notice: "Thumbnails rebuilt!"
  end
end
