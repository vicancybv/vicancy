ActiveAdmin.register User do

  action_item only: :show do |user|
    link_to('New Video for this User', new_admin_video_url('video[user_id]' => params[:id]))
  end

  form do |f|
    f.inputs 'User' do
      f.input :name, label: "Reseller name"
      f.input :slug, label: "Address", hint: "e.g. aw6g39vk. Created automatically if left blank."
      f.input :language,  
              as: :select,      
              collection: { 
                "English" => "en", 
                "Dutch" => "nl"
              }
    end
    f.actions
  end

  show do |user|
    attributes_table do
      row :id
      row :name
      row :language
      row :url do |user|
        link_to user_url(user.slug), user_url(user.slug)
      end
    end

    panel "Videos" do
      table_for user.videos do
        column "ID" do |video| 
          link_to video.id, edit_admin_video_url(video)
        end
        column :company
        column :job_title
        column :created_at
      end

    end

    panel "Video requests" do
      table_for user.video_requests do
        column "ID" do |video_request| 
          link_to video_request.id, admin_video_request_url(video_request)
        end
        column :link
        column :comment
        column :files do |video_request|
          video_request.attachments.count
        end
      end

    end

  end
  
end
