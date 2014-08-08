ActiveAdmin.register VideoRequest do

  form do |f|
    f.inputs I18n.t('admin.User') do
      f.input :user
    end
    f.inputs I18n.t('admin.client') do
      f.input :client
    end
    f.inputs I18n.t('admin.Video request') do
      f.input :link, label: "Link"
      f.input :comment, label: "Comments"
    end

    

    f.actions
  end

  show do |video_request|
    attributes_table do
      row 'Client' do |video_request|
        video_request.client.present? ? link_to(video_request.client_name, admin_client_url(video_request.client)) : nil
      end
      row :id
      row :link
      row :comment
    end

    panel "Files" do
      table_for video_request.attachments do
        column "Filename" do |attachment| 
          link_to attachment.file_file_name, attachment.file.expiring_url(1.week)
        end
        column do |attachment| 
          link_to "Download", download_attachment_url(attachment)
        end
      end

    end

  end
  
end
